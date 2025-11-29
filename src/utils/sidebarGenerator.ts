import type {
    PropSidebarItem,
} from '@docusaurus/plugin-content-docs';

type SidebarItemsGenerator = (args: {
    defaultSidebarItemsGenerator: (args: any) => Promise<PropSidebarItem[]>;
    [key: string]: any;
}) => Promise<PropSidebarItem[]>;

/**
 * Custom sidebar items generator that automatically assigns unique keys to categories.
 * This resolves duplicate key issues when multiple directories have the same name.
 */
export const sidebarItemsGenerator: SidebarItemsGenerator = async ({
    defaultSidebarItemsGenerator,
    ...args
}) => {
    const sidebarItems = await defaultSidebarItemsGenerator(args);

    // Helper to recursively add unique keys to categories
    const addUniqueKeys = (items: PropSidebarItem[], prefix = ''): PropSidebarItem[] => {
        return items.map((item) => {
            if (item.type === 'category') {
                // Generate a unique key based on the path of labels
                // e.g. "Docker_Tools_Docker"
                const uniqueKey = prefix ? `${prefix}_${item.label}` : item.label;

                // Return new item with explicit key if not already set
                return {
                    ...item,
                    // Only set key if not manually defined
                    // Using the label path ensures uniqueness across the tree
                    key: (item.customProps?.key as string) || uniqueKey,
                    items: addUniqueKeys(item.items, uniqueKey),
                };
            }
            return item;
        });
    };

    return addUniqueKeys(sidebarItems);
};
