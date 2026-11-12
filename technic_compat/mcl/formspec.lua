-- MCL-compatible formspec styling for technic machines
-- When running under MineClonia, technic formspecs need explicit slot
-- background images, since MineClonia uses transparent listcolors and
-- relies on image[] elements with mcl_formspec_itemslot.png for visible slots.

-- Generate slot background image elements directly
-- This avoids any dependency on mcl_formspec module load order
if technic_compat.mcl then
    technic_compat.get_itemslot_bg = function(x, y, w, h)
        local out = ""
        for i = 0, w - 1 do
            for j = 0, h - 1 do
                out = out .. "image[" .. (x + i) .. "," .. (y + j) .. ";1,1;mcl_formspec_itemslot.png]"
            end
        end
        return out
    end
else
    -- No-op when not running MCL
    technic_compat.get_itemslot_bg = function(x, y, w, h)
        return ""
    end
end

-- Empty prefix - MCL's set_formspec_prepend handles global styling
technic_compat.formspec_prefix = ""
