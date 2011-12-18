#pragma once

#include <GL\glui.h>
#include <math.h>
#include <iostream>
#include "Auxiliary.h"

class Knight{
public:
	Knight();
	Knight(unsigned int pos_x, unsigned int pos_y, float color[3]);
	~Knight();
	void render(float scale);
	void animate(unsigned int pos_x_init, unsigned int pos_y_init, unsigned int pos_x_new, unsigned int pos_y_new);
	unsigned int get_pos_x(){return this->pos_x;}
	unsigned int get_pos_y(){return this->pos_y;}
private:
	unsigned int pos_x;
	unsigned int pos_y;
	float color[3];
};