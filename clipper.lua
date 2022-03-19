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
    local infile = mp.get_property("path")
    local audio_track_id = mp.get_property("aid")

    print(infile, "to", outfile)

    local args = {
        'mpv',
        infile,
        '--loop-file=no',
        '--no-ocopy-metadata',
        '--no-sub',
        table.concat { '--start=', start_time },
        table.concat { '--end=', end_time },
        table.concat { '--aid=', audio_track_id },
        table.concat { '-o=', outfile }
    }

    local process_result = function(success, result, err)
        if success then
            mp.osd_message(string.format("Rendered %s - %s to %s", start_time, end_time, outfile))
        else
            mp.osd_message("Rendering failed.")
        end
    end

    mp.command_native_async({
        name = "subprocess",
        args = args
    }, process_result)
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

