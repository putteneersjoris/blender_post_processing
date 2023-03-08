mkdir mpeg2 
for I in *.mp4;
    do
        ffgac -i "$I" \
            -an -vcodec mpeg2video -f rawvideo \
            -mpv_flags +nopimb \
            -qscale:v 9 \
            -r 24 \
            -g 144 \
            -s 1024x1024 \
            -y mpeg2/"${I/.mp4/.mpg}";
    done

cd mpeg2 
mkdir frames
let x=10 
for I in *.mpg;
    do
        ffgac -i "$I" -vcodec copy frames/datamosh_${x}_%04d.raw;
        let x=x+1;
    done

cd frames
mkdir concat_frames

cat datamosh_11_0001.raw $(ls | xargs -n 20  | sort --random-sort) > datamosh_concatenated.mp4
# cat datamosh_11_0001.raw $(ls | xargs -n 20 | sort --random-sort) > datamosh_concatenated.mp4
# cat datamosh_11_0001.raw $(ls | xargs -n 20) > datamosh_concatenated.mp4


# ffmpeg -i "datamosh_concatenated.mp4" -vf fps=3/1 "concat_frames/out-%05d.jpg"
ffmpeg -i "datamosh_concatenated.mp4" -vf fps=5/1 "concat_frames/out-%05d.jpg"

# post processing
cd concat_frames
mkdir ../../../dither
magick convert *.jpg -sharpen 0x1.1  -ordered-dither o8x8,6 \
    -fill white -pointsize 50 -undercolor black -bordercolor black -border 5x5 -gravity NorthWest -annotate +15+15 'joris putteneers' \
    -fill white -pointsize 20 -undercolor black -bordercolor black -border 5x5 -gravity NorthWest -annotate +21+85 '%f' \
    -fill white -pointsize 20 -undercolor black -bordercolor black -border 5x5 -gravity SouthWest -annotate +21+23 'negotiating creativity through datamoshing' \
    -set -comment "%m:%f %wx%h" \
    -set filename:base "%[basename]" ../../../dither/"%[filename:base]_dithered.jpg"