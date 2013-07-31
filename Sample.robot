#! /usr/bin/env python
# -*- coding: latin-1 -*-

from sys import stderr
from rtb import Robot, RobotColours

def debug(message):
	stderr.write('D %s%s' % (message, '\n'))

class SampleRobot(Robot):
	def unhandled(self, name):
		debug('unhandled `%s` event' % name)
	
if __name__ == '__main__':
	ROBOT_NAME = "Sample"
	ROBOT_COLOURS = RobotColours(first_choice='386273', second_choice='d97154')
	
	robot = SampleRobot(ROBOT_NAME, ROBOT_COLOURS)
	robot.start()

