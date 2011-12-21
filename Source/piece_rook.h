#pragma once

#include <GL\glui.h>
#include <math.h>
#include <iostream>
#include "Auxiliary.h"

class Rook{
public:
	Rook();
	Rook(unsigned int pos_x, unsigned int pos_y, float color[3]);
	~Rook();
	void render(float scale);
	unsigned int get_pos_x(){return this->pos_x;}
	unsigned int get_pos_y(){return this->pos_y;}
	void set_pos_x(unsigned int npx){this->pos_x = npx;}
	void set_pos_y(unsigned int npy){this->pos_y = npy;}
private:
	unsigned int pos_x;
	unsigned int pos_y;
	float color[3];
};