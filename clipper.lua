local utils = require("mp.utils")

local homedir
-- might not work on windows?
for _, item in ipairs(utils.get_env_list()) do
    local key, val = string.match(item, "(.*)=(.*)")
    if key == "HOME" then
        homedir = val
    end
end

function get_sub_times()
    local sub_start = mp.get_property_number("sub-start")
    local sub_end = mp.get_property_number("sub-end")
    return {sub_start, sub_end}
end

function render_clip(start_time, end_time, name)
    local basedir = homedir
    local outfile = string.format("%s/Videos/%s.mp4", basedir, name)
    local infile = mp.get_property_osd("filename")
    print(infile, "to", outfile)
    local result = mp.commandv(
        "run", "ffmpeg",
        "-n", -- no overwrite
        "-loglevel", "quiet",
        "-ss", tostring(start_time),
        "-to", tostring(end_time),
        "-i", infile,
        "-t", tostring(end_time - start_time),
        outfile
    )

    if result then
        mp.osd_message(string.format("Rendered %s - %s", start_time, end_time))
    else
        mp.osd_message("Failed to render clip")
    end
end

function show_sub_time()             
    local sub_start = get_sub_times()[1]
    local sub_end = get_sub_times()[2]
    mp.osd_message(string.format("%s - %s", sub_start, sub_end))
end

function render_current_sub()
    local filename = mp.get_property_osd("filename/no-ext")
    local sub_start = get_sub_times()[1]
    local sub_end = get_sub_times()[2]
    render_clip(sub_start, sub_end, string.format("%s %s-%s", filename, sub_start, sub_end))
end

mp.add_key_binding('g', "show_sub_time", show_sub_time)
mp.add_key_binding('G', "render_current_sub", render_current_sub)

