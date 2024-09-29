# logitech-webcam-fix

This systemd unit configuration file and the bash script it starts fix two problems of the Logitech B500: the chipmunk sound and the often too dark image.

The bash script continuously checks if a new usb audio or video device is being used. This could mean that the webcam microphone or video is being used.
It then either resets the camera (using usbreset) or enables then disables the auto exposure and manually sets the gain using v4l2-ctl.

## Usage

If you use the systemd unit configuration file, you have to modify the ExecStart value to point to the bash script location on your system.

You can change the gain in the bash script.

## Requirements
- usbreset (found in usbutils)
- v4l2-ctl (found in v4l-utils)
