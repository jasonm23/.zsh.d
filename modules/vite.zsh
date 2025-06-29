
patch_tsconfig() {
  jq '
    .compilerOptions.paths["@/*"] = ["src/*"] |
    .compilerOptions.baseUrl = "."
  ' tsconfig.json > tsconfig.tmp.json && mv tsconfig.tmp.json tsconfig.json
}

patch_viteconfig() {
  sed -E -i -e 's|plugins: \[(.*react.*)\]|plugins: [\1, tailwindcss()]|' vite.config.ts 2>/dev/null
  cat <(<<<"import tailwindcss from '@tailwindcss/vite'") vite.config.ts | tee vite_temp
  mv vite_temp vite.config.ts
  bat -P --style plain vite.config.ts
}

patch_css() {
  cat <(<<<'@import "tailwindcss";') src/index.css > index.css
  mv index.css src/
}

vite_tailwind_ts_react_shadcn (){
    if [[ $# == 0 ]]
    then
        echo "usage: $0 <name>"
        return
    fi
    npm create vite@latest $1 -- --template react-ts
    cd $1
    npm install
    echo "\n🔨 patching vite.config.ts...\n"
    patch_viteconfig
    echo "\n🔨 patching tsconfig.json...\n"
    patch_tsconfig
    echo "\n🔨 installing modules...\n"
    npm install -D tailwindcss postcss autoprefixer
    npm install tailwindcss tailwindcss-animate postcss autoprefixer @tailwindcss/vite
    echo "\n🔨 installing jest...\n"
    npm i -D jest jest-environment-jsdom jest-transform-stub ts-jest @types/jest @testing-library/react
    npx ts-jest config:init
    mv jest.config.js jest.config.cjs
    echo "\n🔨 patching src/index.css...\n"
    patch_css
    echo "\n🔨 installing shadcn...\n"
    yes | npx shadcn@latest init
    npx shadcn@latest add sonner button dialog input card
    git init
    git remote add origin git@gitcodo.hub:ocodo/$1.git
    if ! git ls-remote origin &>/dev/null; then
      echo "\n\n💡 Making repo git@gitcodo.hub:ocodo/$1 ...\n"
        tea repo create --owner ocodo --name $1
    else
      echo "\n\n👍 set origin git@gitcodo.hub:ocodo/$1 ...\n"
    fi
    echo "\n\nReady ✅\n"

    echo "\n\nRunning dev...\n"
    vite --host 0.0.0.0
}
