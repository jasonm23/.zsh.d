
vite_tailwind_ts_react_shadcn (){
    if [[ $# == 0 ]]
    then
        echo "usage: $0 <name>"
        return
    fi

    npm create vite@latest $1 -- --template react-ts
    cd $1
    npm install
    npm install -D tailwindcss postcss autoprefixer
    npx tailwindcss init -p
    npm install -D tailwindcss-animate
    npx shadcn-ui@latest init

    cat <<EOF

   💡 Making repo git@gitcodo.hub:ocodo/$1 ..."

EOF
    git init
    git remote add origin git@gitcodo.hub:ocodo/$1.git
    tea repo create --owner ocodo --name $1
    # TODO ... something

    cat <<EOF

   Ready ✅

   npm run dev

EOF
}
