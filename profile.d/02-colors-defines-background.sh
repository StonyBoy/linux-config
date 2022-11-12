# Steen Hegelund
# Time-Stamp: 2022-Nov-12 15:27

if [[ $TERM == "linux" ]]; then
    # Regular Colors
    TERM_BLUE_OR_YELLOW=$TERM_YELLOW

    # Bold
    TERM_BOLD_BLUE_OR_YELLOW=$TERM_BOLD_YELLOW

    # Underline
    TERM_ULINE_BLUE_OR_YELLOW=$TERM_ULINE_YELLOW

    # Background
    TERM_ON_BLUE_OR_YELLOW=$TERM_ON_YELLOW

    # High Intensty
    TERM_IBLUE_OR_IYELLOW=$TERM_IYELLOW

    # Bold High Intensty
    TERM_BIBLUE_OR_BIYELLOW=$TERM_BIYELLOW

    # High Intensty backgrounds
    TERM_ON_IBLUE_OR_IYELLOW=$TERM_ON_IYELLOW

    unset TERM_LIGHT_BACKGROUND
    TERM_DARK_BACKGROUND=1
else
    # Regular Colors
    TERM_BLUE_OR_YELLOW=$TERM_BLUE

    # Bold
    TERM_BOLD_BLUE_OR_YELLOW=$TERM_BOLD_BLUE

    # Underline
    TERM_ULINE_BLUE_OR_YELLOW=$TERM_ULINE_BLUE

    # Background
    TERM_ON_BLUE_OR_YELLOW=$TERM_ON_BLUE

    # High Intensty
    TERM_IBLUE_OR_IYELLOW=$TERM_IBLUE

    # Bold High Intensty
    TERM_BIBLUE_OR_BIYELLOW=$TERM_BIBLUE

    # High Intensty backgrounds
    TERM_ON_IBLUE_OR_IYELLOW=$TERM_ON_IBLUE

    unset TERM_DARK_BACKGROUND
    TERM_LIGHT_BACKGROUND=1
fi
