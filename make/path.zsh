m() {
    make -f ".m.mk" "$@"
}

me() {
    if [ ! -f ".m.mk" ]; then
        echo "The file .m.mk does not exist. Would you like to create it? (y/n)"
        read answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            touch ".m.mk"
            echo "Created empty .m.mk file."
        else
            echo "Operation cancelled."
            return 1
        fi
    fi
    code .m.mk
}
