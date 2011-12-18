#ifndef _SCENE_H_
#define _SCENE_H_

#include <GL\glui.h>
#include <math.h>
#include <iostream>
#include <string>
#include "RGBpixmap.h"
#include "piece_bishop.h"
#include "piece_king.h"
#include "piece_knight.h"
#include "piece_pawn.h"
#include "piece_queen.h"
#include "piece_rook.h"

class Scene{

public:
	Scene(){};
	void Draw_Axis(GLUquadric* glQ);
	void Draw_Rectangle (float x1, float y1, float x2, float y2, std::string axis, bool normal, unsigned int texture_number, float s, float t);
	void Draw_PositionBoard(unsigned int idT);
	void Draw_Board();
	void Draw_LegTable();
	void Draw_Floor();
	void Draw_Table();

	void Draw_Scene(GLenum mode);
	void Draw_Pieces();
};

#endif