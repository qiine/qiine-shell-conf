
# bash functions


## pkgs
#----------------------------------------------------------------------
info() {
    local cmd="$1"

    local cmdtype
    cmdtype=$(type -a "${cmd}")
    printf "│Cmdtype: %s\n" "${cmdtype}"

    local vers
    vers=$("$cmd" --version 2>&1 || "$cmd" -v 2>&1 || "$cmd" -V 2>&1)
    printf "│Version: %s\n" "$(echo "$vers" | head -n 1)"

    local what
    what=$(whatis "${cmd}")
    printf "│Whatis:  %s\n" "${what}"

    local which
    which=$(which "${cmd}")
    printf "│Which:   %s\n" "${which}"

    local whereis
    whereis=$(whereis "${cmd}")
    printf "│Whereis: %s\n" "${whereis}"
}

inst() {
    #check existing
    if dpkg -l | grep -q "^ii  $1 ";
    then
        echo "$1 is already installed";
        echo "Here: "; whereis "$1" | tr ' ' '\n';
        return
    fi

    sudo apt install "$1";

    status=$?
    if [ "$status" -eq 0 ];
    then
        echo "----------------------------------------------------------------------------------------------------"
        echo "$1 was installed here: "; whereis "$1" | tr ' ' '\n';

    else
        echo "Installation failed for '$1' !";
    fi
}

link2locbin() {
    local name
    name="$(basename "$1")"
    name="${name%%.*}"  # need to strip extension

    ln -sfnv "$1" "$HOME/.local/bin/$name"
}

# change tty font size
change_font_size()
{
    FONTSIZE="16x32"

    local action="$1"
    local num size
    num=$(echo "$FONTSIZE" | grep -oE '^[0-9]+')  # Extract number (e.g., 16 from 16x32)
    size=$(echo "$FONTSIZE" | grep -oE 'x[0-9]+') # Extract size part (e.g., x32)

    if [[ "$action" == "inc" ]]; then
        num=$((num + 2))  # Increase by 2 (adjust as needed)
    elif [[ "$action" == "dec" ]]; then
        num=$((num - 2))  # Decrease by 2
    fi

    FONTSIZE="${num}${size}"
    setfont "/usr/share/consolefonts/Lat15-TerminusBold${FONTSIZE}.psf.gz"
}

alias ttyfont+="change_font_size()"
alias ttyfont-="change_font_size()"


## fs
#----------------------------------------------------------------------
# fancy cd with fzf search and tree
cdf() {
    local base_dir="${1:-$HOME}"
    local selected_dir
    selected_dir=$(fd -t d . "$base_dir" | fzf +m \
            --height=50% \
            --preview 'tree -C {}' \
            --preview-window=right:30%)
    if [[ -n "$selected_dir" ]]; then
        cd "$selected_dir" || return 1
    fi
}

# Chain cd and ls
cdl() {
    builtin cd "$@" && ll
}

mkcd() {
    [[ -n "$1" ]] || return 1     # check non empty
    mkdir -p -- "$1" || return 1
    cd -- "$1" || return 1
}

# facny rsync with progress view
rsyncp() {
    du -sh "$1"
    rsync -rlptDUHAX -c --info=progress2 --stats -h "$1" "$2"
}


checkhash() {
    dir="${1}"
    echo "Check dir hash: ${dir}"
    hash=$(tar cf - --sort=name --pax-option=exthdr.name=%d/PaxHeaders/%f "${dir}" | sha256sum | awk '{print $1}')
    echo "${dir} sha256: ${hash}"
    # tar cf - --sort=name --pax-option=exthdr.name=%d/PaxHeaders/%f "$1" | sha256sum
    # tar cf -
    # c → create a new archive
    # f - → output to stdout instead of a file (- means stdout)
    # means the entire directory is streamed to the next command instead of being
    # written to disk.
    # --sort=name
    # Ensures files are processed in alphabetical order
    # Without this, the order of files can vary depending on the filesystem, which would make the hash different even if the content is identical.
    # --pax-option=exthdr.name=%d/PaxHeaders/%f
    # Tar uses the PAX format to store extra metadata (like long filenames, extended attributes) in “extended headers.”
    # exthdr.name=%d/PaxHeaders/%f sets a predictable path for these headers inside the archive.
    # This ensures reproducibility, so repeated runs on the same directory give the same hash.
    # Without this, tar may assign a random temporary path for extended headers,
    # which would change the hash even if files are identical.
    # | awk '{print $1} rem - at end of hash bc of "cf -"
}

comparehash() {
    if rsync -avc --dry-run "${1}" "${2}" | grep -q '^'; then
        echo "hashes differs"
    else
        echo "hashes identical"
    fi
}

flattenfiletree() {
    find . -type f -exec mv -n -t . {} +                # mv all non dup files to cwd
    find . -mindepth 1 -type d -empty -print -delete    # rem empty dirs recursively
}

rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
        local file
        file="$(
                FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
                fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                --phony -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="70%:wrap"
               )" &&
        echo "opening $file" &&
        xdg-open "$file"
}

ddimg() {
    input="${1:?Missing input file!}"
    name="${2:-blockdevice}"    # optional, defaults to blockdevice

    sudo dd if="$input" of="$HOME/Desktop/$name.img" \
        bs=4M \
        status=progress \
        conv=noerror,sync
}


## Utils
#----------------------------------------------------------------------
fcmd() {
    compgen -c | \
    sort -u | \
    fzf --preview 'type {} && echo && man {} | col -bx | head -40' --preview-window=right:60%
}


# db
frmtdb() {
    jq -r 'to_entries | map(.value | tostring) | @tsv' "$1" | column -t -s$'\t' > "${1%.jsonl}.table.txt"
    echo "saved: ${1%.jsonl}.table.txt"
}
# jq -r 'to_entries[] | .value | @tsv' "$1" | column -t -s $'\t'
# jq -r 'keys_unsorted as $k | $k[] as $f | .[$f] | @tsv' "${1}" | column -t -s $'\t'

jsonl2csv() {
    local in="${1}"
    local name="${in%.jsonl}"
    mlr --ijsonl --ocsv cat "${in}" > "${name}.csv"
}

## Media
#----------------------------------------------------------------------
### PDF
pdf2img() {
    local in="${1}"
    local name="${in%.pdf}"
    local out="${name}.png"

    pdftoppm "${in}" name -png -r 200
}

imgtopdf() {
    # if [[ ! -f "$1" ]]; then
    #     echo "Error: File '$1' not found."
    #     return 1
    # fi
    #
    # local in="${1}"
    # local name="${in%.*}"
    # local out="${name}.pdf"

    command img2pdf "${@}" -o "out.pdf"
}

pdfmerge() {
    qpdf --empty --pages "${@}" -- "out_merged.pdf"
    echo "Merged:" "${@}"
}

pdfunlock() {
    local in="${1}"
    local name="${in%.pdf}"
    local out="${name}_unlocked.pdf"
    local passw

    # checks
    [ -z "$in" ] && { echo "Usage: pdfunlock file.pdf"; return 1; }
    [ ! -f "$in" ] && { echo "File not found: $in"; return 1; }

    read -rs -p "Password: " passw    # more secure, password from stdin
    echo

    qpdf --password="$passw" --decrypt "$in" "$out"

    unset passw # clear password from memory

    echo "Unlocked: $out"
}



## VC
#----------------------------------------------------------------------


## org
#----------------------------------------------------------------------
# dstask helper
t() {
    if [[ -z "$1" ]]; then
        dstask
        return
    fi

    dstask add "$*"
}

iban_mod97() {
    iban=$(printf '%s' "$1" | tr -d ' ' | tr '[:lower:]' '[:upper:]')

    s=$(printf '%s' "$iban" | cut -c5-)
    s="${s}$(printf '%s' "$iban" | cut -c1-4)"

    rem=0
    i=1
    while [ "$i" -le "${#s}" ]; do
        c=$(printf '%s' "$s" | cut -c "$i")

        case "$c" in
            [A-Z]) v=$(( $(printf '%d' "'$c") - 55 )) ;;
            *)     v=$c ;;
        esac

        for d in $(printf '%s' "$v" | sed 's/./& /g'); do
            rem=$(( (rem * 10 + d) % 97 ))
        done

        i=$((i + 1))
    done

    if [ "$rem" -eq 1 ]; then
        printf 'valid\n'
    else
        printf 'invalid\n'
    fi
}


## AI
#----------------------------------------------------------------------



## Nix
#----------------------------------------------------------------------
nixchkopt() {
    nix eval ~/Personal/dotfiles/System/NixOS/.#nixosConfigurations.asuround.config."${1}"
}

nixwhere() {
    nix eval nixpkgs#"${1}".outPath
}



## Android
#----------------------------------------------------------------------
adbls() {
    mapfile -t SERIALS < <(adb devices | awk 'NR>1 && $2=="device"{print $1}')

    echo "Serial | Brand | Model | Android-version"
    echo "────────────────────────────────────────"
    for serial in "${SERIALS[@]}"; do
        brand=$(adb -s "$serial" shell getprop ro.product.brand)
        model=$(adb -s "$serial" shell getprop ro.product.model)
        version=$(adb -s "$serial" shell getprop ro.build.version.release)
        echo "$serial $brand $model Android:$version"
    done
}

adbpkgfind() {
    pick=$(adb shell pm list packages -a | cut -d: -f2 | fzf --height=50%)
    [[ -n "$pick" ]] && echo "$pick"
}


