#!/usr/bin/env python3

# Copyright (C) 2023 by Jasonm23 / ocodo
# Licenced under GPL v3 see LICENSE
# See README.md for more info

import argparse
import random
import os
import pyglet

update_interval_seconds = 6.0
pan_speed_x = 0
pan_speed_y = 0
zoom_speed = 0
image_paths = []
image_index = 0
ken_burns = True
random_image = False
sprite = None
staus_label = None
status_label_display_duration = 2
paused = False
window = pyglet.window.Window(fullscreen=True)

def osd(message):
    pyglet.clock.unschedule(hide_status_message)
    status_label.text = message
    status_label.opacity = 255
    pyglet.clock.schedule_once(hide_status_message, status_label_display_duration)

def hide_status_message(dt):
    status_label.opacity = 0

def update_pan_zoom_speeds():
    global pan_speed_x, pan_speed_y, zoom_speed
    pan_speed_x = random.randint(-8, 8)
    pan_speed_y = random.randint(-8, 8)
    zoom_speed = random.uniform(-0.02, 0.02)

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

def previous_image():
    global random_image, image_index, image_paths
    if random_image:
        image = random.choice(image_paths)
        image_index = image_paths.index(image)
        return pyglet.image.load(image)
    else:
        if image_index > 0:
            image_index -= 1
        else:
            image_index = len(image_paths) - 1

    img = pyglet.image.load(image_paths[image_index])
    sprite.image = img
    sprite.scale = get_initial_scale(window, img)
    sprite.x = (window.width - sprite.width) / 2
    sprite.y = (window.height - sprite.height) / 2
    update_pan_zoom_speeds()
    window.clear()

def next_image():
    global random_image, image_index
    if random_image:
        image = random.choice(image_paths)
        image_index = image_paths.index(image)
        return pyglet.image.load(image)
    else:
        if image_index < len(image_paths) - 1:
            image_index += 1
        else:
            image_index = 0

        return pyglet.image.load(image_paths[image_index])

def update_image(dt):
    img = next_image()
    sprite.image = img

    if ken_burns:
        sprite.scale = get_initial_scale(window, img)
    else:
        sprite.scale = get_fit_scale(window, img)

    sprite.x = (window.width - sprite.width) / 2
    sprite.y = (window.height - sprite.height) / 2

    if ken_burns:
        update_pan_zoom_speeds()

    window.clear()

def get_image_paths(input_dir='.'):
    paths = []
    for root, dirs, files in os.walk(input_dir, topdown=True):
        for file in sorted(files):
            if file.endswith(('jpg', 'png', 'gif')):
                path = os.path.abspath(os.path.join(root, file))
                paths.append(path)
    return paths

def is_landscape(image):
    return image.width > image.height

def get_initial_scale(window, image):
    if is_landscape(image):
        scale = window.width * random.uniform(1, 1.3) / image.width
    else:
        scale = window.height * random.uniform(1, 1.3) / image.height

    return scale

def get_fit_scale(window, image):
    if is_landscape(image):
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

@window.event
def on_draw():
    window.clear()
    sprite.draw()
    status_label.draw()

@window.event
def on_key_release(symbol, modifiers):
    global random_image, update_interval_seconds, ken_burns, paused
    key = pyglet.window.key

    if key.Q == symbol or key.ESCAPE == symbol:
        pyglet.app.exit()

    elif key.SPACE == symbol:
        paused = not paused
        if paused:
            pause()
        else:
            resume()

    elif key.R == symbol:
        random_image = not random_image
        if random_image:
            osd(f"Random")
        else:
            osd(f"Sequence")

    elif key.K == symbol:
        ken_burns = not ken_burns
        if ken_burns:
            osd(f"Ken Burns Effect: On")
        else:
            osd(f"Ken Burns Effect: Off")

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
        update_interval_seconds = float(symbol - 48) / 2.0
        reset_clock()

@window.event
def on_mouse_release(*args):
    update_image(0)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('dir', help='directory of images', nargs='?', default=os.getcwd())
    args = parser.parse_args()

    image_paths = get_image_paths(args.dir)
    img = pyglet.image.load(image_paths[0])
    sprite = pyglet.sprite.Sprite(img)
    sprite.scale = get_initial_scale(window, img)
    sprite.x = (window.width - sprite.width) / 2
    sprite.y = (window.height - sprite.height) / 2

    status_label = pyglet.text.Label(
        '',
        font_name='Helvetica Neue',
        font_size=18,
        x=10,
        y=10,
        color=(255, 255, 255, 255)
    )

    pyglet.clock.schedule_interval(update_image, update_interval_seconds)
    pyglet.clock.schedule_interval(update_pan, 1/60.0)
    pyglet.clock.schedule_interval(update_zoom, 1/60.0)

    pyglet.app.run()
