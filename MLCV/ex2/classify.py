#!/usr/bin/env python

import sys
import os
import numpy as np
import matplotlib.pyplot as plt
import scipy

# import caffe
CAFFE_ROOT = '/home/adam/workspace/caffe/caffe/'
CAFFE_PYTHON_ROOT = os.path.join(CAFFE_ROOT, 'python')
sys.path.append(CAFFE_PYTHON_ROOT)
import caffe


MODEL_FILE = 'models/bvlc_reference_caffenet/deploy.prototxt'
MODEL_FILE = os.path.join(CAFFE_ROOT, MODEL_FILE)
PRETRAINED = 'models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel'
PRETRAINED = os.path.join(CAFFE_ROOT, PRETRAINED)
MEAN_FILE = os.path.join(CAFFE_ROOT, 'python/caffe/imagenet/ilsvrc_2012_mean.npy')
SYNSET_FILE = os.path.join(CAFFE_ROOT, 'data/ilsvrc12/synset_words.txt')
DATA_FOLDER = 'data'
IMG_SIZE = (256, 256)

PROB_LAYER = 'prob'

def read_synset():
    synset = []
    with open(SYNSET_FILE) as f:
        for line in f:
            splitted = line.strip().split()
            synset.append((splitted[0], ' '.join(splitted[1:])))

    synset.sort()
    synset = [entry[1] for entry in synset]
    return synset

def resizeToLonger(img, longer):
    imgWidth = img.shape[1]
    imgHeight = img.shape[0]

    ratio = 0;
    if imgWidth > imgHeight:
        imgHeight = int(imgHeight / float(imgWidth) * longer)
        imgWidth = longer 
    else:
        imgWidth = int(imgWidth / float(imgHeight) * longer)
        imgHeight = longer

    print imgHeight, imgWidth
    return caffe.io.resize_image(img, (imgHeight, imgWidth)) 

def padTo(img, width, height):
    wPad = (width - img.shape[1]) / 2
    wPadOdd = (width - img.shape[1]) % 2
    hPad = (height - img.shape[0]) / 2
    hPadOdd = (height - img.shape[0]) % 2
    pad = ((hPad, hPad + hPadOdd), (wPad, wPad + wPadOdd))
    if len(img.shape) - 2:
        pad += ((0, 0) * (len(img.shape) - 2),)

    return np.pad(img, pad, 'constant', constant_values=0)


def load_images():
    imgs = []
    for img_file in os.listdir(DATA_FOLDER):
        img = caffe.io.load_image(os.path.join(DATA_FOLDER, img_file))
        img = resizeToLonger(img, IMG_SIZE[0])
        img = padTo(img, *IMG_SIZE)
        imgs.append((img_file, img))

    return imgs


if __name__ == '__main__':
    mean_file = np.load(MEAN_FILE)
    caffe.set_mode_cpu()
    net = caffe.Classifier(MODEL_FILE, PRETRAINED, 
            mean=mean_file.mean(1).mean(1),
            channel_swap=(2,1,0),
            raw_scale=255,
            image_dims=IMG_SIZE
            )
    synset = read_synset()

    outputs = []
    for img_name, input_image in load_images():

        # show input image
        plt.imshow(input_image)
        plt.show()
        input_resized = caffe.io.resize_image(input_image, net.image_dims)
        input_oversampled = caffe.io.oversample([input_resized], net.crop_dims)
        caffe_input = np.asarray([net.transformer.preprocess('data', in_) for in_ in input_oversampled])

        net.forward(data=caffe_input) 
        probs = net.blobs[PROB_LAYER].data
        probs = probs.reshape((len(probs) / 10, 10, -1))
        probs = probs.mean(1)
        probs = probs.reshape(-1)
        predicted_class = probs.argmax()
        class_label = synset[predicted_class]
        class_probability = probs[predicted_class]
        entropy = scipy.stats.entropy(probs)

        outputs.append((img_name, predicted_class, class_label, class_probability, entropy))
        print outputs[-1]


