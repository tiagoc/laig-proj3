#include "Scene.h"
#include <string>

using namespace std;

// Axis declarations
double axis_radius_begin =  0.2;
double axis_radius_end   =  0.0;
double axis_lenght       = 16.0;
int axis_nslices = 8;
int axis_nstacks = 1;

// Origin sphere declarations
double orig_radius = 0.5;
int orig_slices = 8;
int orig_stacks = 16;

float white[3]={0.0,255.0,0.0};
float black[3]={0.0,0.0,255.0};

// Pieces
King White_King(1,5,white);
Queen White_Queen(1,4,white);
Bishop White_Bishop_1(1,3,white);
Bishop White_Bishop_2(1,6,white);
Knight White_Knight_1(1,2,white);
Knight White_Knight_2(1,7,white);
Rook White_Rook_1(1,1,white);
Rook White_Rook_2(1,8,white);
Pawn White_Pawn_1(2,1,white);
Pawn White_Pawn_2(2,2,white);
Pawn White_Pawn_3(2,3,white);
Pawn White_Pawn_4(2,4,white);
Pawn White_Pawn_5(2,5,white);
Pawn White_Pawn_6(2,6,white);
Pawn White_Pawn_7(2,7,white);
Pawn White_Pawn_8(2,8,white);

King Black_King(8,5,black);
Queen Black_Queen(8,4,black);
Bishop Black_Bishop_1(8,3,black);
Bishop Black_Bishop_2(8,6,black);
Knight Black_Knight_1(8,7,black);
Knight Black_Knight_2(8,2,black);
Rook Black_Rook_1(8,1,black);
Rook Black_Rook_2(8,8,black);
Pawn Black_Pawn_1(7,1,black);
Pawn Black_Pawn_2(7,2,black);
Pawn Black_Pawn_3(7,3,black);
Pawn Black_Pawn_4(7,4,black);
Pawn Black_Pawn_5(7,5,black);
Pawn Black_Pawn_6(7,6,black);
Pawn Black_Pawn_7(7,7,black);
Pawn Black_Pawn_8(7,8,black);


void Scene::Draw_Axis(GLUquadric* glQ){

	glPushMatrix();
	// Origin sphere
	glColor3f(1.0,1.0,1.0);		
	gluSphere(glQ, orig_radius, orig_slices, orig_stacks);

	// X axis - Red
	glColor3f(1.0,0.0,0.0);
	glPushMatrix();
	glRotated(90.0, 0.0,1.0,0.0 );
	gluCylinder(glQ, axis_radius_begin, axis_radius_end, axis_lenght, axis_nslices, axis_nstacks);
	glPopMatrix();

	// Y axis - Green
	glColor3f(0.0,1.0,0.0);		
	glPushMatrix();
	glRotated(-90.0, 1.0,0.0,0.0 );
	gluCylinder(glQ, axis_radius_begin, axis_radius_end, axis_lenght, axis_nslices, axis_nstacks);
	glPopMatrix();
	
	// Z axis - Blue
	glColor3f(0.0,0.0,1.0);
	glPushMatrix();
	gluCylinder(glQ, axis_radius_begin, axis_radius_end, axis_lenght, axis_nslices, axis_nstacks);
	glPopMatrix();

	glPopMatrix();
}

void Scene::Draw_Rectangle (float x1, float y1, float x2, float y2, string axis, bool normal, unsigned int texture_number, float s, float t)
{
	// Bool normal - 1 se normal no sentido positivo, 0 se no sentido negativo

	float _normal;
	if (normal==1)
		_normal=1.0;
	else if (normal==0)
		_normal=-1.0;

	int axis_int=0;
	if(axis=="x")
		axis_int=1;
	else if (axis=="y")
		axis_int=2;
	else if (axis=="z")
		axis_int=3;

	//float xx = (x2-x1)/s;
	//float yy = (y2-y1)/t;
	float xx = s;
	float yy = t;

	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, texture_number);

	switch(axis_int){
	case 1:
		glPushMatrix();
			glBegin(GL_POLYGON);
				glNormal3d(_normal,0.0,0.0);
				glTexCoord2f(0.0, 0.0);
				glVertex3d(0.0, x1, y1);
				glTexCoord2f(xx, 0.0);
				glVertex3d(0.0, x1, y2);
				glTexCoord2f(xx, yy);
				glVertex3d(0.0, x2, y2);
				glTexCoord2f(0.0, yy);
				glVertex3d(0.0, x2, y1);
			glEnd();
		glPopMatrix();
		break;
	case 2:
		glPushMatrix();
			glBegin(GL_POLYGON);
				glNormal3d(0.0,_normal,0.0);
				glTexCoord2f(0.0, 0.0);
				glVertex3d(x1, 0.0, y1);
				glTexCoord2f(xx, 0.0);
				glVertex3d(x1, 0.0, y2);
				glTexCoord2f(xx, yy);
				glVertex3d(x2, 0.0, y2);
				glTexCoord2f(0.0, yy);
				glVertex3d(x2, 0.0, y1);
			glEnd();
		glPopMatrix();
		break;
	case 3:
	glPushMatrix();
		glBegin(GL_POLYGON);
			glNormal3d(0.0,0.0,_normal);
			glTexCoord2f(0.0, 0.0);
			glVertex3d(x1, y1, 0.0);
			glTexCoord2f(xx, 0.0);
			glVertex3d(x1, y2, 0.0);
			glTexCoord2f(xx, yy);
			glVertex3d(x2, y2, 0.0);
			glTexCoord2f(0.0, yy);
			glVertex3d(x2, y1, 0.0);
		glEnd();
	glPopMatrix();
	break;}

	glDisable(GL_TEXTURE_2D);
}

void Scene::Draw_PositionBoard(unsigned int idT){
	glPushMatrix();
		glTranslated(8.0,0.0,1.0);
		glPushMatrix();
			glTranslated(0.0,0.5,0.0);
			Draw_Rectangle(0.0,0.0,1.0,1.0, "y", 1, idT, 1.0, 1.0);
		glPopMatrix();
	glPopMatrix();
}

void Scene::Draw_Board(){
	glDisable(GL_CULL_FACE);
	glPushMatrix();

		Draw_Rectangle(0.0,0.0,10.0,0.5, "z", 0, 3, 1, 1);
		glPushMatrix();
			glTranslated(0.0,0.0,12.0);
			Draw_Rectangle(0.0,0.0,10.0,0.5, "z", 1, 3, 1, 1);
		glPopMatrix();
		Draw_Rectangle(0.0,0.0,0.5,12.0, "x", 0, 3, 1, 1);
		glPushMatrix();
			glTranslated(10.0,0.0,0.0);
			Draw_Rectangle(0.0,0.0,0.5,12.0, "x", 1, 3, 1, 1);
		glPopMatrix();

		glPushMatrix();
			glTranslated(0.0,0.5,0.0);
			glPushMatrix();
				Draw_Rectangle(0.0,0.0,10.0,2.0, "y", 1, 3, 1, 1);
				Draw_Rectangle(0.0,10.0,10.0,12.0, "y", 1, 3, 1, 1);
				Draw_Rectangle(0.0,2.0,1.0,10.0, "y", 1, 3, 1, 1);
				Draw_Rectangle(9.0,1.0,10.0,10.0, "y", 1, 3, 1, 1);
			glPopMatrix();
		glPopMatrix();
		

	glPopMatrix();
	glEnable(GL_CULL_FACE);
}

void Scene::Draw_LegTable(){
	glPushMatrix();
		glTranslated(0.0,-15.0,0.0);
		glPushMatrix();
			Draw_Rectangle(0.0,0.0,1.5,1.5, "y", 0, 1, 1.0, 1.0);
			glPushMatrix();
				glTranslated(0.0,1.5,0.0);
				Draw_Rectangle(0.0,0.0,1.5,1.5, "y", 1, 1, 1.0, 1.0);
			glPopMatrix();
			Draw_Rectangle(0.0,0.0,1.5,15.0, "z", 0, 1, 1.0, 1.0);
			glPushMatrix();
				glTranslated(0.0,0.0,1.5);
				Draw_Rectangle(0.0,0.0,1.5,15.0, "z", 1, 1, 1.0, 1.0);
			glPopMatrix();
			Draw_Rectangle(0.0,0.0,15.0,1.5, "x", 0, 1, 1.0, 1.0);
			glPushMatrix();
				glTranslated(1.5,0.0,0.0);
				Draw_Rectangle(0.0,0.0,15.0,1.5, "x", 1, 1, 1.0, 1.0);
			glPopMatrix();
		glPopMatrix();
	glPopMatrix();
}

void Scene::Draw_Floor()
{
	Draw_Rectangle(-60.0,-60.0,60.0,60.0,"y", 1, 2, 10.0, 10.0);
}

void Scene::Draw_Table(){
	glDisable(GL_CULL_FACE);
	glPushMatrix();
	glTranslated(0.0,-1.5,0.0);
	glPushMatrix();
		Draw_Rectangle(0.0,0.0,15.0,15.0, "y", 0, 1, 1.0, 1.0);
		glPushMatrix();
		glTranslated(0.0,1.5,0.0);
		Draw_Rectangle(0.0,0.0,15.0,15.0, "y", 1, 1, 1.0, 1.0);
		glPopMatrix();
		Draw_Rectangle(0.0,0.0,15.0,1.5, "z", 0, 1, 1.0, 1.0);
		glPushMatrix();
		glTranslated(0.0,0.0,15.0);
		Draw_Rectangle(0.0,0.0,15.0,1.5, "z", 1, 1, 1.0, 1.0);
		glPopMatrix();
		Draw_Rectangle(0.0,0.0,1.5,15.0, "x", 0, 1, 1.0, 1.0);
		glPushMatrix();
		glTranslated(15.0,0.0,0.0);
		Draw_Rectangle(0.0,0.0,1.5,15.0, "x", 1, 1, 1.0, 1.0);
		glPopMatrix();

		glPushMatrix();
			Draw_LegTable();
		glPopMatrix();

		glPushMatrix();
			glTranslated(13.5,0.0,13.5);
			Draw_LegTable();
		glPopMatrix();

		glPushMatrix();
			glTranslated(13.5,0.0,0.0);
			Draw_LegTable();
		glPopMatrix();

		glPushMatrix();
			glTranslated(0.0,0.0,13.5);
			Draw_LegTable();
		glPopMatrix();
	glPopMatrix();

	glPopMatrix();
	glEnable(GL_CULL_FACE);
}

void Scene::Draw_Pieces()
{
	White_King.render(0.001);
	White_Queen.render(0.001);
	White_Bishop_1.render(0.001);
	White_Bishop_2.render(0.001);
	White_Knight_1.render(0.001);
	White_Knight_2.render(0.001);
	White_Rook_1.render(0.001);
	White_Rook_2.render(0.001);
	/*White_Pawn_1.render(0.001);
	White_Pawn_2.render(0.001);
	White_Pawn_3.render(0.001);
	White_Pawn_4.render(0.001);
	White_Pawn_5.render(0.001);
	White_Pawn_6.render(0.001);
	White_Pawn_7.render(0.001);
	White_Pawn_8.render(0.001);*/

	Black_King.render(0.001);
	Black_Queen.render(0.001);
	Black_Bishop_1.render(0.001);
	Black_Bishop_2.render(0.001);
	Black_Knight_1.render(0.001);
	Black_Knight_2.render(0.001);
	Black_Rook_1.render(0.001);
	Black_Rook_2.render(0.001);
	/*Black_Pawn_1.render(0.001);
	Black_Pawn_2.render(0.001);
	Black_Pawn_3.render(0.001);
	Black_Pawn_4.render(0.001);
	Black_Pawn_5.render(0.001);
	Black_Pawn_6.render(0.001);
	Black_Pawn_7.render(0.001);
	Black_Pawn_8.render(0.001);*/
}
/*
void Scene::Draw_Scene(GLenum mode){
	glPushMatrix();
	glPushMatrix();
		glPushMatrix();
		glTranslated(0.0,-16.5,0.0);
		Draw_Floor();
		glPopMatrix();
		glTranslated(-5.0,0.0,-6.0);
		Draw_Board();
		int n = 0;
		glPushMatrix();
			int tex = 0;
			for(int i = 0; i < sizeBoard; i++){
				glTranslatef(-sizeBoard,0.0,1.0);
				for(int j = 0; j < sizeBoard; j++){	
					if((i%2) == 0){
						if(j%2 == 0) tex=4;
						else tex=3;
					} else {
						if(j%2 == 0) tex=3;
						else tex=4;
					}
					/*n++;
					if(mode == GL_SELECT){
						glLoadName(n);
					}
					glTranslatef(1.0,0.0,0.0);
					Draw_PositionBoard(tex);
				}
			}
		glPopMatrix();
	glPopMatrix();
		
	glPushMatrix();
		glTranslated(-7.5,0.0,-7.5);
		Draw_Table();
	glPopMatrix();

	glPushMatrix();
	glTranslated(-3.5,1.6,3.5);
	Draw_Pieces();
	glPopMatrix();

	glPopMatrix();
}*/