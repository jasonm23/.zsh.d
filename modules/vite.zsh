
patch_tsconfig() {
    jq '
    .compilerOptions.paths["@/*"] = ["src/*"] |
    .compilerOptions.baseUrl = "."
  ' tsconfig.json > tsconfig.tmp.json && mv tsconfig.tmp.json tsconfig.json
}

patch_viteconfig() {
    cat <<-EOF > vite.config.ts
import tailwindcss from '@tailwindcss/vite'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  server: {
    allowedHosts: []
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src/'),
    },
  },
  plugins: [react(), tailwindcss()],
})
EOF
}

patch_app_tsx() {
    cat <<EOF > src/App.tsx
import { Heading } from '@/components/heading';
import { ThemeProvider } from '@/contexts/theme-provider';
import { cn } from '@/lib/utils';
import type { FC } from 'react';

const App:FC = () => (
  <ThemeProvider>
    <div>
      <Heading title='$1'/>
      <div>....</div>
    </div>
  </ThemeProvider>
)

export default App
EOF
}

patch_heading() {
    cat <<-EOF > src/components/heading.tsx
import { Menu, Moon, Sun } from 'lucide-react'
import { toast } from 'sonner'
import { useContext, useEffect } from 'react'
import { ThemeContext } from '@/contexts/theme-context'
import { ThemeSwitch } from '@/components/theme-switch'

interface HeadingProps {
  title: string
}

export const Heading = ({title}: HeadingProps) => (
    <header className="flex items-center justify-between p-4 border-b">
      <div className="p-2 hover:bg-accent cursor-pointer rounded-lg">
        <Menu className="h-6 w-6" />
      </div>
      <div className="font-black tracking-tighter text-2xl">{title}</div>
      <ThemeSwitch />
    </header>
  )
EOF
}
vite_tailwind_ts_react_shadcn (){
    if [[ $# == 0 ]]
    then
        echo "usage: $0 <name>"
        return
    fi
    pnpm create vite@latest $1 -- --template react-ts
    cd $1
    mkdir -p src/components/ui
    mkdir -p src/{contexts,hooks}
    pnpm install
    echo "\n🔨 patching vite.config.ts ...\n"
    patch_viteconfig
    echo "\n🔨 patching tsconfig.json ...\n"
    patch_tsconfig
    echo "\n🔨 installing modules...\n"
    pnpm add -D tailwindcss postcss autoprefixer
    pnpm add tailwindcss tailwindcss-animate postcss autoprefixer @tailwindcss/vite
    echo "\n🔨 installing jest...\n"
    pnpm add -D jest jest-environment-jsdom jest-transform-stub ts-jest @types/jest @testing-library/react
    pnpx ts-jest config:init
    mv jest.config.js jest.config.cjs
    echo "\n🔨 patching src/index.css ...\n"
    patch_css
    echo "\n🔨 patching src/App.tsx ...\n"
    patch_use_local_storage
    echo "\n🔨 patching src/hooks/use-local-storage.ts ...\n"
    patch_app_tsx "${1}"
    echo "\n🔨 adding index.html \n"
    cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$1</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Geist:wght@100..900&display=swap" rel="stylesheet">
  </head>
  <body class="transition-all duration-1800 relative overflow-hidden" style="scroll-behavior: smooth;">
    <div class="body-background-image transition-all duration-1500 z-1 absolute top-0 left-0 right-0 h-[1000px]"></div>
    <div class="body-background-gradient transition-all duration-1500 z-2 absolute top-0 left-0 right-0 h-[1000px]"></div>
    <div id="root" class="absolute top-0 left-0 right-0 h-[100vh] overflow-scroll z-10"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF
    if [[ -d ~/workspace/hnstories  ]]; then
	echo "\n🔨 adding index.css\n"
	cp ~/workspace/hnstories/src/index.css src/
	echo "\n🔨 patching src/contexts/theme-context.tsx ...\n"
	cp ~/workspace/hnstories/src/contexts/theme-context.tsx src/contexts/
	echo "\n🔨 patching src/contexts/theme-provider.tsx ...\n"
	cp ~/workspace/hnstories/src/contexts/theme-provider.tsx src/contexts/
	echo "\n🔨 patching src/components/heading.tsx ...\n"
	patch_heading
    fi

    if [[ -d ~/workspace/uvxytdlp ]]; then
	echo "\n🔨 adding ocodo-ui components from uvxytdlp \n"
	echo " ⨁  long-press-button.tsx"
	cp ~/workspace/uvxytdlp/src/components/ocodo-ui/long-press-button.tsx src/components
	echo " ⨁  switch-state.tsx"
	cp ~/workspace/uvxytdlp/src/components/ocodo-ui/switch-state.tsx src/components
	echo " ⨁  select-state.tsx ..."
	cp ~/workspace/uvxytdlp/src/components/ocodo-ui/switch-state.tsx src/components
	echo " ⨁  theme-switch.tsx ..."
	cp ~/workspace/uvxytdlp/src/components/theme-switch/theme-switch.tsx src/components
    fi
    echo "\n🔨 installing shadcn...\n"
    yes | pnpx shadcn@latest init
    pnpx shadcn@latest add sonner button dialog input card switch

    echo "\n🔨 cleaning up...\n"

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
