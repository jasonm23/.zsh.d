#!/bin/bash

collect-ocodo-react-components() {
    # Target directory
    TARGET_DIR=$HOME/workspace/ocodo-react-components/src/components
    mkdir -p $TARGET_DIR
    echo "💡 Collecting react components from workspace"

    # Find all relevant TSX files
    find ~/workspace/ -type f -name "*.tsx" | grep -v "node_modules" | while read -r file; do
        # Check if the file contains either export const or React.FC
        if rg -q "(export\s+const|React\.FC)" "$file"; then
            # Get the filename and copy it to the target directory
            filename=$(basename "$file")
            cp -v "$file" "$TARGET_DIR/$filename"
        fi
    done

    echo "Components have been copied to $TARGET_DIR"
}
