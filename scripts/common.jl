using befwm
using Gadfly
using DataFrames
using Colors

function distrmax(x)
    return mean(x) .+ std(x)
end

function distrmin(x)
    return mean(x) .- std(x)
end

gfont = "Liberation Sans"

plab_theme = Theme(
    default_color = RGB(0.1, 0.1, 0.1),
    highlight_width = 0mm,
    errorbar_cap_length = 0mm,
    panel_stroke = RGB(0.3, 0.3, 0.3),
    grid_color = RGB(0.3, 0.3, 0.3),
    grid_line_width = 0.1mm,
    lowlight_opacity = 0.3,
    minor_label_font = gfont,
    major_label_font = gfont,
    key_title_font = gfont,
    key_label_font = gfont,
    minor_label_color = colorant"black",
    major_label_color = colorant"black"
)
