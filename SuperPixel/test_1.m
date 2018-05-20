close all;clear;clc;warning off all;

img_left = imread('6left.png'); 
img_right = imread('6right.png'); 


[left_point,right_point] = match(img_left,img_right,1,1);



