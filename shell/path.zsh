organize_files() {
    extensions=($(ls -dp *.* | perl -pe 's/.*\.//' | sort -u | grep -v '/$'))
    echo "$extensions" | tr 'A-Z' 'a-z' | xargs mkdir -p
    for ext in "${extensions[@]}"; do
        lxt=$(echo $ext | tr 'A-Z' 'a-z')
        mv *.$ext $lxt
    done
}
