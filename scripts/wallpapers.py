#!/usr/local/pyvenv/steen/bin/python3
'''
Use JPEG photo as wallpaper images.

You can rename image files and convert, size and crop them
You can also set them as lockscreen or wallpaper

Installation:
    source /usr/local/pyvenv/steen/bin/activate
    pip install -r requirements.txt
    deactivate

'''
import os
import os.path
import argparse
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont
import random
import subprocess
import socket
import datetime
import time
import re
import glob


def parse_arguments():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--interval', help='Refresh image with this interval in secs (run as service)', type=int, default=0)
    parser.add_argument('--sway', help='Set sway wallpaper to wallpaper.jpg file', action='store_true')
    parser.add_argument('--niri', help='Set niri wallpaper to wallpaper.jpg file', action='store_true')
    parser.add_argument('--i3', help='Set i3 wallpaper to wallpaper.jpg file', action='store_true')
    parser.add_argument('--crop', help='Crop from left or top percentage (0-100)', type=int, default=50)
    parser.add_argument('--lockscreen', help='Create lockscreen.jpg file', action='store_true')
    parser.add_argument('--wallpaper', help='Create wallpaper.jpg file', action='store_true')
    parser.add_argument('--login', help='Create login_screen.jpg file', action='store_true')
    parser.add_argument('--info', help='Add text about the system to the final image', action='store_true')
    parser.add_argument('--network', help='Network interface used for system information', default='wan')
    parser.add_argument('width', help='Display Width', type=int, default=2560)
    parser.add_argument('height', help='Display Height', type=int, default=1440)
    parser.add_argument('path', help='Path to images')
    return parser.parse_args(), parser


def wait_for_swaysock():
    swaysock = glob.glob('/run/user/*/sway-ipc.*')
    while len(swaysock) == 0:
        print('Waiting for a sway socket')
        time.sleep(2.0)
        swaysock = glob.glob('/run/user/*/sway-ipc.*')


def set_wallpaper(args):
    if args.interval == 0:
        args.interval = None
    cmd = []
    wppath = os.path.join(args.path, 'wallpaper.jpg')
    if args.sway:
        cmd = ['swaymsg', f'output * bg {wppath} fill']
    if args.niri:
        cmd = ['swaybg', '-i', wppath]
    if args.i3:
        cmd = ['feh', '--bg-fill', wppath]
    try:
        subprocess.run(cmd, timeout=args.interval)
    except subprocess.TimeoutExpired:
        return False
    if args.sway and args.interval:
        time.sleep(args.interval)
        return False
    return True


def scale_to_display(newfullpath, fullpath, displaysize, crop):
    with Image.open(fullpath) as image:
        if image.size[0] / image.size[1] > displaysize[0] / displaysize[1]:
            print('Crop from left using {}%'.format(crop))
            # Larger aspect ratio, use fixed height: displayheight
            newsize = int(image.size[0] / image.size[1] * displaysize[1]), displaysize[1]
            newimage = image.resize(newsize)
            # Crop from Left Box: left, upper, right, and lower pixel coordinate.
            startx = (newsize[0] - displaysize[0]) * crop // 100
            box = startx, 0, startx + displaysize[0], displaysize[1]
            print('imagesize {} on display {} resized to {} and crop box {}'
                  .format(image.size, displaysize, newsize, box))
            croppedimage = newimage.crop(box)
            croppedimage.save(newfullpath)
        else:
            print('Crop from top using {}%'.format(crop))
            newsize = displaysize[0], int(displaysize[0] / image.size[0] * image.size[1])
            newimage = image.resize(newsize)
            # Crop from Top Box: left, upper, right, and lower pixel coordinate.
            starty = (newsize[1] - displaysize[1]) * crop // 100
            box = 0, starty, displaysize[0], starty + displaysize[1]
            print('imagesize {} on display {} resized to {} and crop box {}'
                  .format(image.size, displaysize, newsize, box))
            croppedimage = newimage.crop(box)
            croppedimage.save(newfullpath)


def select_random_image(filepath):
    images = [p for p in os.listdir(filepath) if p.endswith('.jpg')]
    choice = random.randrange(len(images))
    return os.path.join(filepath, images[choice])


def draw_text(draw, text, size=100, top=10, left=10, outline=2):
    shadowcolor = (250, 250, 250)
    try:
        font = ImageFont.truetype('Inconsolata-Regular.ttf', size)
    except OSError:
        font = ImageFont.truetype('Inconsolata.otf', size)
    # Add an outline
    draw.text((top - outline, left - outline), text, font=font, fill=shadowcolor)
    draw.text((top + outline, left - outline), text, font=font, fill=shadowcolor)
    draw.text((top - outline, left + outline), text, font=font, fill=shadowcolor)
    draw.text((top + outline, left + outline), text, font=font, fill=shadowcolor)
    # Text on top
    draw.text((top, left), text, font=font, fill=(255, 0, 0))
    return top + size


def get_if_ipv4(ifname):
    cp = subprocess.run(['ip', 'addr', 'show', ifname], capture_output=True)
    lines = cp.stdout.decode().split('\n')
    ipv4_regex = re.compile(r'\s+inet\s+(\S+)/\S+')
    for line in lines:
        mt = ipv4_regex.match(line)
        if mt:
            return mt[1]
    return socket.gethostbyname(os.uname().nodename)


def add_system_info(args, filepath, top=16, left=10):
    now = datetime.date.today().strftime('%d-%b-%Y')
    img = Image.open(filepath)
    draw = ImageDraw.Draw(img)
    size = 60
    top += draw_text(draw, f'User: {os.environ["USER"]}', size, left, top)
    top += draw_text(draw, f'Hostname: {os.uname().nodename}', size, left, top)
    top += draw_text(draw, f'IPv4: {get_if_ipv4(args.network)}', size, left, top)
    top += draw_text(draw, f'Date: {now}', size, left, top)
    img.save(filepath)


if __name__ == '__main__':
    done = True
    args, parser = parse_arguments()

    if len(args.path):
        if args.sway:
            wait_for_swaysock()
        while True:
            fullpath = select_random_image(os.path.abspath(args.path))
            if args.lockscreen:
                newname = 'lockscreen.jpg'
            elif args.wallpaper:
                newname = 'wallpaper.jpg'
            elif args.login:
                newname = 'login_wallpaper.jpg'
            else:
                newname = 'cropped_image.jpg'
            newfullpath = os.path.join(os.path.dirname(fullpath), newname)
            scale_to_display(newfullpath, fullpath, (args.width, args.height), args.crop)
            if args.info:
                add_system_info(args, newfullpath)
            print('Created', newfullpath)
            if args.wallpaper:
                if set_wallpaper(args):
                    break
            elif args.lockscreen and args.interval > 0:
                time.sleep(args.interval)
            elif args.login_wallpaper and args.interval > 0:
                time.sleep(args.interval)
            else:
                break
    else:
        parser.print_help()
