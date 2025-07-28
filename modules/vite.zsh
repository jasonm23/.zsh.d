
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

patch_use_local_storage() {
    mkdir -p src/hooks
    cat <<-EOF > src/hooks/use-local-storage.ts
import { useState } from 'react';

export const useLocalStorage = (key: string, initialValue: any) => {
  const [value, setValue] = useState(() => {
    try {
      const storedValue = localStorage.getItem(key);
      if (storedValue != undefined) {
        return JSON.parse(storedValue)
      } else {
        localStorage.setItem(key, JSON.stringify(initialValue));
        return initialValue
      }

    } catch (error) {
      console.error(error);
      localStorage.setItem(key, JSON.stringify(initialValue));
      return initialValue;
    }
  });

  const saveToLocalStorage = (newValue: any) => {
    setValue(newValue);
    localStorage.setItem(key, JSON.stringify(newValue));
  };

  return [value, saveToLocalStorage];
};
EOF
}

patch_theme_provider() {
    mkdir -p src/contexts
    cat <<-EOF > src/contexts/theme-provider.tsx
import React, { useEffect } from "react";
import type { FC, ReactNode } from "react";
import { useLocalStorage } from "@/hooks/use-local-storage";
import { ThemeContext } from "@/contexts/theme-context";

export const ThemeProvider: FC<{ children: ReactNode }> = ({ children }) => {
  const [theme, setTheme] = useLocalStorage("theme", "light");

  useEffect(() =>
    theme == 'dark'
      ? document.body.classList.add('dark')
      : document.body.classList.remove('dark')
  , [theme])

  const toggleTheme = () =>
    (theme == 'light')
      ? setTheme('dark')
      : setTheme('light')


  return (
    <ThemeContext.Provider value={{
      theme,
      toggleTheme
    }}>
      {children}
    </ThemeContext.Provider>
  );
};

EOF
}

patch_theme_context() {
    mkdir -p src/contexts
    cat <<-EOF > src/contexts/theme-context.tsx
import { createContext } from "react";

export const ThemeContext = createContext({
  theme: 'light',
  toggleTheme: () => {}
});

EOF
}

patch_heading() {
    cat <<-EOF > src/components/heading.tsx
import { Menu, Moon, Sun } from 'lucide-react'
import { toast } from 'sonner'
import { useContext, useEffect } from 'react'
import { ThemeContext } from '@/contexts/theme-context'

interface HeadingProps {
  title: string
}

function Heading(props: HeadingProps) {
  const { title } = props
  const { toggleTheme, theme } = useContext(ThemeContext)

  useEffect(() => (
    console.log(`Theme: ${theme}`)
  ), [theme])

  return (
    <header className="flex items-center justify-between p-4 border-b">
      <div className="p-2 hover:bg-accent cursor-pointer rounded-lg">
        <Menu className="h-6 w-6" />
      </div>
      <div className="font-black tracking-tighter text-2xl">{title}</div>
      <div
        className="p-2 hover:bg-accent cursor-pointer rounded-lg"
        onClick={() => toggleTheme()}
      >
        {theme === 'light' ? <Moon className="h-6 w-6" /> : <Sun className="h-6 w-6" />}
      </div>
    </header>
  )
}

export { Heading }

EOF
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
    pnpm create vite@latest $1 -- --template react-ts
    cd $1
    mkdir -p src/components/ui
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
    echo "\n🔨 patching src/contexts/theme-context.tsx ...\n"
    patch_theme_context
    echo "\n🔨 patching src/contexts/theme-provider.tsx ...\n"
    patch_theme_provider
    echo "\n🔨 patching src/components/heading.tsx ...\n"
    patch_heading
    if [[ -d ~/workspace/uvxytdlp ]]; then
	    echo " ⨁  long-press-button.tsx"
	    cp ~/workspace/uvxytdlp/src/components/ocodo-ui/long-press-button.tsx src/components
	    echo " ⨁  switch-state.tsx"
	    cp ~/workspace/uvxytdlp/src/components/ocodo-ui/switch-state.tsx src/components
	    echo " ⨁  select-state.tsx ..."
	    cp ~/workspace/uvxytdlp/src/components/ocodo-ui/switch-state.tsx src/components
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
