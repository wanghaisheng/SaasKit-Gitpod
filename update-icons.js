import { readFileSync, writeFileSync } from 'fs';
import { join } from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Map of svelte-radix icons to their lucide-svelte equivalents
const iconMap = {
    'DotsHorizontal': 'MoreHorizontal',
    'ChevronLeft': 'ChevronLeft',
    'ArrowRight': 'ArrowRight',
    'Check': 'Check',
    'CaretSort': 'ChevronsUpDown',
    'MagnifyingGlass': 'Search',
    'DragHandleDots2': 'GripVertical',
    'ChevronRight': 'ChevronRight',
    'DotFilled': 'Circle',
    'Cross2': 'X',
    'Minus': 'Minus',
    'Plus': 'Plus',
    'Calendar': 'Calendar',
    'EnvelopeClosed': 'Mail',
    'Face': 'Smile',
    'Gear': 'Settings',
    'Person': 'User',
    'Rocket': 'Rocket',
    'ExclamationTriangle': 'AlertTriangle',
    'Bell': 'Bell',
    'FontItalic': 'Italic',
    'FontBold': 'Bold',
    'Underline': 'Underline',
    'Sun': 'Sun',
    'Moon': 'Moon',
    'PaperPlane': 'Send',
    'Circle': 'Circle',
    'Star': 'Star',
    'Reload': 'RotateCw',
    'Slash': 'Slash'
};

// Function to update imports in a file
function updateFile(filePath) {
    try {
        let content = readFileSync(filePath, 'utf8');
        let modified = false;

        // Replace svelte-radix imports with lucide-svelte imports
        for (const [radixIcon, lucideIcon] of Object.entries(iconMap)) {
            const radixImport = `import ${radixIcon} from "svelte-radix/${radixIcon}.svelte"`;
            if (content.includes(radixImport)) {
                content = content.replace(
                    radixImport,
                    `import { ${lucideIcon} } from "lucide-svelte"`
                );
                // Also replace any usage of the icon in the file
                content = content.replace(
                    new RegExp(`<${radixIcon}([^>]*)>`, 'g'),
                    `<${lucideIcon}$1>`
                );
                modified = true;
            }
        }

        if (modified) {
            writeFileSync(filePath, content, 'utf8');
            console.log(`Updated ${filePath}`);
        }
    } catch (error) {
        console.error(`Error processing ${filePath}:`, error);
    }
}

// Process all files in the UI components directory
const componentsDir = join(__dirname, 'src', 'lib', 'components', 'ui');
const files = [
    'carousel-previous.svelte',
    'carousel-next.svelte',
    // Add other files as needed
].map(file => join(componentsDir, file));

files.forEach(updateFile);