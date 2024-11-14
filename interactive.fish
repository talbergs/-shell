for i in (fd --exclude "*.pub" --type file "id_*" ~/.ssh/)
    keychain --eval --agents ssh -Q $i | source
end
