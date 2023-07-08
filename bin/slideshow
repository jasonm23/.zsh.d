#!/usr/bin/env python3

# Copyright (C) 2023 by Jasonm23 / ocodo
# Licenced under GPL v3 see LICENSE
# See README.md for more info

import os
import sys
import argparse
import random
import pyglet
import pyperclip

update_interval_seconds = 6.0
mouse_hide_delay = 3.0
pan_speed_x = 0
pan_speed_y = 0
zoom_speed = 0
image_paths = []
image_index = 0
image_filename = ""
img = None
sprite = None
ken_burns = True
random_image = False
staus_label = None
status_label_hide_delay = 2
paused = False
window = pyglet.window.Window(resizable=True,style='borderless')

def osd(message):
    pyglet.clock.unschedule(hide_status_message)
    status_label.text = message
    status_label.opacity = 255
    pyglet.clock.schedule_once(hide_status_message, status_label_hide_delay)

def hide_status_message(dt):
    status_label.opacity = 0

def randomize_pan_zoom_speeds():
    global pan_speed_x, pan_speed_y, zoom_speed
    pan_speed_x = random.randint(-8, 8)
    pan_speed_y = random.randint(-8, 8)
    zoom_speed = random.uniform(-0.01,-0.001)

def update_pan(dt):
    if ken_burns:
        sprite.x += dt * pan_speed_x
        sprite.y += dt * pan_speed_y

def update_zoom(dt):
    if ken_burns:
        if zoom_speed < 0:
            sprite.scale += dt * (zoom_speed * 3)
        else:
            sprite.scale += dt * zoom_speed
        sprite.scale = max(sprite.scale, 1)

def load_image(image):
    image = pyglet.image.load(image)
    return image

def setup_sprite():
    if ken_burns:
        sprite.scale = get_oversize_scale(window, img)
    else:
        sprite.scale = get_fit_scale(window, img)

    sprite.x = (window.width - sprite.width) / 2
    sprite.y = (window.height - sprite.height) / 2

def previous_image():
    global random_image, image_index, image_filename, img
    if random_image:
        image_filename = random.choice(image_paths)
        image_index = image_paths.index(image_filename)
        return load_image(image_filename)
    else:
        if image_index > 0:
            image_index -= 1
        else:
            image_index = len(image_paths) - 1

    image_filename = image_paths[image_index]
    img = load_image(image_filename)
    sprite.image = img

    setup_sprite()

    if ken_burns:
        randomize_pan_zoom_speeds()

    window.clear()

def next_image():
    global random_image, image_index, image_filename, img
    if random_image:
        image_filename = random.choice(image_paths)
        image_index = image_paths.index(image_filename)
        img = load_image(image_filename)
        return img
    else:
        if image_index < len(image_paths) - 1:
            image_index += 1
        else:
            image_index = 0

        image_filename = image_paths[image_index]
        img = load_image(image_filename)
        return img

def update_image(dt):
    global img
    img = next_image()
    sprite.image = img

    setup_sprite()

    if ken_burns:
        randomize_pan_zoom_speeds()

    window.clear()

def hide_mouse(dt):
    window.set_mouse_visible(visible=False)

def get_image_paths(input_dir='.'):
    paths = []
    for f in os.listdir(input_dir):
        if f.endswith(('jpg', 'jpeg', 'png', 'gif')):
            path = os.path.abspath(os.path.join(input_dir, f))
            paths.append(path)

    return paths

def get_image_paths_from_stdin():
    paths = []
    for f in sys.stdin:
        f = f.rstrip()
        if f.endswith(('jpg', 'jpeg', 'png', 'gif')):
            paths.append(f)

    return paths

def is_landscape(image):
    return image.width > image.height

def is_larger(image, window):
    return image.width > window.width and image.height > window.height

def get_oversize_scale(window, image):
    if is_landscape(image):
        scale = window.width * 1.3 / image.width
    else:
        scale = window.height * 1.3 / image.height

    return scale

def get_fit_scale(window, image):
    if is_landscape(image):
        if is_larger(image, window):
            scale = window.height / image.height
        else:
            scale = window.width / image.width
    else:
        scale = window.height / image.height

    return scale

def reset_clock():
    osd(f"Interval: {update_interval_seconds:.2f}")
    pyglet.clock.unschedule(update_image)
    pyglet.clock.schedule_interval(update_image, update_interval_seconds)

def pause():
    osd("Paused")
    pyglet.clock.unschedule(update_image)

def resume():
    osd("Resume")
    pyglet.clock.schedule_interval(update_image, update_interval_seconds)

def toggle_ken_burns():
    global ken_burns
    ken_burns = not ken_burns
    if ken_burns:
        osd(f"Ken Burns Effect: On")
    else:
        osd(f"Ken Burns Effect: Off")

def toggle_pause():
    global paused
    paused = not paused
    if paused:
        pause()
    else:
        resume()

def toggle_random_image():
    global random_image
    random_image = not random_image
    if random_image:
        osd(f"Random")
    else:
        osd(f"Sequence")

def window_max_size():
    screen = window.display.get_default_screen()
    width = screen.width
    height = screen.height

    window.set_location(0,0)
    window.width = width
    window.height = height

@window.event
def on_draw():
    window.clear()
    sprite.draw()
    status_label.draw()

@window.event
def on_key_release(symbol, modifiers):
    global update_interval_seconds
    key = pyglet.window.key

    if key.Q == symbol or key.ESCAPE == symbol:
        pyglet.app.exit()

    elif key.SPACE == symbol:
        toggle_pause()

    elif key.R == symbol:
        toggle_random_image()

    elif key.F == symbol:
        window_max_size()

    elif key.K == symbol:
        toggle_ken_burns()

    elif key.I == symbol:
        osd(f"Filename copied to clipboard...")
        pyperclip.copy(image_filename)

    elif key.LEFT == symbol:
        previous_image()

    elif key.RIGHT == symbol:
        update_image(0)

    elif key.BRACKETLEFT == symbol:
        update_interval_seconds = max(update_interval_seconds - 0.5, 0.5)
        reset_clock()

    elif key.BRACKETRIGHT == symbol:
        update_interval_seconds = max(update_interval_seconds + 0.5, 0.5)
        reset_clock()

    elif symbol in [key._1, key._2, key._3, key._4, key._5, key._6, key._7, key._8, key._9]:
        update_interval_seconds = float(symbol - 48)
        reset_clock()

@window.event
def on_mouse_release(x, y, button, modifiers):
    width = window.width
    if button == pyglet.window.mouse.LEFT:
        if x < width * 0.5:
            previous_image()
        elif x > width * 0.5:
            update_image(0)
    elif button == pyglet.window.mouse.RIGHT:
        if x < width * 0.3:
            toggle_random_image()
        elif x > width * 0.6:
            toggle_ken_burns()
        else:
            toggle_pause()

@window.event
def on_mouse_scroll(x, y, scroll_x, scroll_y):
    global update_interval_seconds
    if scroll_y < 0:
        update_interval_seconds = max(update_interval_seconds + 0.5, 0.5)
    else:
        update_interval_seconds = max(update_interval_seconds - 0.5, 0.5)

    reset_clock()

@window.event
def on_mouse_motion(x, y, dx, dy):
    window.set_mouse_visible(visible=True)
    pyglet.clock.schedule_once(hide_mouse, mouse_hide_delay)

@window.event
def on_resize(width,height):
    setup_sprite()

if __name__ == '__main__':
    args_dir = None
    if len(sys.argv) > 1:
        args_dir = sys.argv[1]

    if args_dir and args_dir == '-h' or args_dir == '--help;':
        print("""
        Usage:

        slideshow [dir]

        slideshow < filename_list

        filenames | slideshow

        ---

        Slideshow will look for jpg, jpeg, png & gif images in the
        file list and display them.

        Control the slideshow:

        Esc,q - quit
        [, ] - change image delay time
        1-9 - change image delay time (number to seconds)
        f - maximize window (fullscreen)
        r - random toggle
        k - Ken Burns effect toggle
        SPACE - pause/resume
        left, right - move between images
        mouse left click - move between images (click on left or right side)

        mouse right click, on screen 3rds
          left side - random/ordered
          middle - pause/resume
          right side - Ken Burns effect toggle

        """)

    if args_dir:
        image_paths = get_image_paths(args_dir)
    else:
        image_paths = get_image_paths_from_stdin()

    if len(image_paths) < 1:
      print(f"No images found in source", file=sys.stderr)
      exit(1)
    else:
      image_filename = image_paths[image_index]
      img = load_image(image_filename)
      sprite = pyglet.sprite.Sprite(img)

      setup_sprite()

      status_label = pyglet.text.Label(
          '',
          font_name='Arial',
          font_size=18,
          x=10,
          y=10,
          color=(255, 255, 255, 255)
      )

      pyglet.clock.schedule_interval(update_image, update_interval_seconds)
      pyglet.clock.schedule_interval(update_pan, 1/60.0)
      pyglet.clock.schedule_interval(update_zoom, 1/60.0)
      pyglet.clock.schedule_once(hide_mouse, mouse_hide_delay)

      pyglet.app.run()
