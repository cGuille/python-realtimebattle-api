python-realtimebattle-api
=========================

Provide a simple Python API to create RealTimeBattle robots.

See [the RealTimeBattle's project page](http://realtimebattle.sourceforge.net/) for details about this programming game.

RealTimeBattle will be abbraviated as "RTB".

# Infos about RTB

RTB is structured as a client/server app:
 * The server is provided to you, and you have to write a client that correspond to a robot;
 * That client is a program;
 * The server will run it as a subprocess and will communicate with it by writing messages to its standard input and reading messages from its standard output.

RTB [provides 3 ways to handle those messages](http://realtimebattle.sourceforge.net/Documentation/RealTimeBattle-4.html#ss4.1).

**Please consider that this API currently support only one of them (the simplest in fact).**

# Python API Usage
The master piece of this API is the `Robot` class provided by the `rtb` Python module. Your own robot will be a class that inherits from this one.

To see a basic sample, check out the file [`Sample.robot`](https://github.com/cGuille/python-realtimebattle-api/blob/master/Sample.robot), which is a really basic robot. This robot do nothing but writing to stderr every non handled action sent by the server.

You can handle all these actions by creating a corresponding method in your own Robot class. For instance, if the Sample robot says that a "radar" event was unhandled, you can choose to handle them by creating a `radar` method like this:
```python
#! /usr/bin/env python
# -*- coding: latin-1 -*-

from rtb import Robot

class MyRobot(Robot):
  def radar(self, distance, observed_object_type, radar_angle):
    if observed_object_type == 'robot':
      self.send_message("I spotted a robot at %f distance from me!" % distance)
```

To know which parameters your method must have, check out the corresponding method signature in the class `RobotInfoListener` into the [`rtb module`](https://github.com/cGuille/python-realtimebattle-api/blob/master/rtb.py).

To know which actions you robot can do, check out the `send_*` methods in the class `RobotActuator` from the same module.

Then, you will have to construct an instance of your robot, giving it a name and some colors to display in the arena. Give the name as a string and the two colors as a tuple of hexa strings. You can import the `RobotColours` named tuple in order to write a more expressive code. Your code now looks like:
```python
#! /usr/bin/env python
# -*- coding: latin-1 -*-

from rtb import Robot, RobotColours

class MyRobot(Robot):
  def radar(self, distance, observed_object_type, radar_angle):
    if observed_object_type == 'robot':
      self.send_message("I spotted a robot at %f distance from me!" % distance)

my_robot = MyRobot("Robot Name", RobotColours(first_choice='386273', second_choice='d97154'))
```

When your robot is ready, just call its `start` method to start reading the server's messages. Here is how it looks now:
```python
#! /usr/bin/env python
# -*- coding: latin-1 -*-

from rtb import Robot, RobotColours

class MyRobot(Robot):
  # If you define an __init__ method for your robot,
  # DO NOT FORGET to call the `Robot` __init__ method, i.e:
  
  # def __init__(self, name, colours):
  #   Robot.__init__(self, name, colours)
  #   # do your stuff…
  
  # Same thing about the `initialize` method, which is already implemented in the
  # `Robot` class. This implementation send the robot name & colours at the right
  # moment. So call the inherited method too if you need to overload it:
  
  # def initialize(self, first):
  #   Robot.initialize(self, first):
  #   # do your stuff…
  
  def radar(self, distance, observed_object_type, radar_angle):
    if observed_object_type == 'robot':
      self.send_message("I spotted a robot at %f distance from me!" % distance)
  
  # Here implement the methods you want
  # (see the RobotInfoListener class to get a list of available methods)

if __name__ == '__main__':
  # We only create and start a robot if this script is runned as a main script
  my_robot = MyRobot("Robot Name", RobotColours(first_choice='386273', second_choice='d97154'))
  my_robot.start()
```
