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

void Scene::Draw_LegTable(unsigned int texture_number){
	glPushMatrix();
		glTranslated(0.0,-15.0,0.0);
		glPushMatrix();
			Draw_Rectangle(0.0,0.0,1.5,1.5, "y", 0, texture_number, 1.0, 1.0);
			glPushMatrix();
				glTranslated(0.0,1.5,0.0);
				Draw_Rectangle(0.0,0.0,1.5,1.5, "y", 1, texture_number, 1.0, 1.0);
			glPopMatrix();
			Draw_Rectangle(0.0,0.0,1.5,15.0, "z", 0, texture_number, 1.0, 1.0);
			glPushMatrix();
				glTranslated(0.0,0.0,1.5);
				Draw_Rectangle(0.0,0.0,1.5,15.0, "z", 1, texture_number, 1.0, 1.0);
			glPopMatrix();
			Draw_Rectangle(0.0,0.0,15.0,1.5, "x", 0, texture_number, 1.0, 1.0);
			glPushMatrix();
				glTranslated(1.5,0.0,0.0);
				Draw_Rectangle(0.0,0.0,15.0,1.5, "x", 1, texture_number, 1.0, 1.0);
			glPopMatrix();
		glPopMatrix();
	glPopMatrix();
}

void Scene::Draw_Floor(unsigned int texture_number)
{
	Draw_Rectangle(-60.0,-60.0,60.0,60.0,"y", 1, texture_number, 10.0, 10.0);
}

void Scene::Draw_impostors(unsigned int texture_number){
	glPushMatrix();
		glPushMatrix();
			glTranslated(0.0, 22.5, 60.0);
			glRotated(90.0, 0.0,0.0,1.0);
			Draw_Rectangle(40.0, 60.0, -40.0, -60.0, "z", 0 ,texture_number, -1.0, -1.0);
		glPopMatrix();
		
		glPushMatrix();
			glTranslated(0.0, 22.5, -60.0);
			glRotated(180.0, 0.0, 1.0, 0.0);
			glRotated(90.0, 0.0,0.0,1.0);
			Draw_Rectangle(40.0, 60.0, -40.0, -60.0, "z", 0 ,texture_number-1, -1.0, -1.0);
		glPopMatrix();
		glPushMatrix();
			glTranslated(-60.0, 22.5, 0.0);
			glRotated(180.0, 0.0, 1.0, 0.0);
			Draw_Rectangle(-40.0,-60.0, 40.0, 60.0, "x", 0 ,texture_number-1, 1.0, 1.0);
		glPopMatrix();
		glPushMatrix();
			glTranslated(60.0, 22.5, 00.0);
			Draw_Rectangle(-40.0, -60.0, 40.0, 60.0, "x", 0 ,texture_number, 1.0, 1.0);
		glPopMatrix();
	glPopMatrix();
}

void Scene::Draw_TablePoker(GLUquadric* glQ, unsigned int tex_tabl, unsigned int tex_topTable){
	glPushMatrix();
	glTranslated(-35.0, 0.0, -25.0);
	glRotated(-45.0, 0.0, 1.0, 0.0);
		glPushMatrix();
			glEnable(GL_NORMALIZE);
			glEnable(GL_TEXTURE_2D);
			glBindTexture(GL_TEXTURE_2D, tex_tabl);
			gluQuadricDrawStyle(glQ, GLU_FILL);
			gluQuadricNormals(glQ,  GLU_SMOOTH);
			gluQuadricOrientation(glQ,  GLU_OUTSIDE);
			gluQuadricTexture(glQ, GL_TRUE);
			glRotated(90.0, 1.0, 0.0, 0.0);
			GLdouble plane[]={0.0,1.0,0.0,0.0};
			glClipPlane(GL_CLIP_PLANE0, plane);
			glEnable(GL_CLIP_PLANE0);
			gluCylinder(glQ, 7.5, 7.5, 17.0, 60.0, 60.0);
			glDisable(GL_CLIP_PLANE0);
		glPopMatrix();

		glPushMatrix();
			glTranslated(-7.5,-17.0,-15.0);
			Draw_Rectangle(0.0, 0.0, 17.0, 17.0, "x", 0, tex_tabl, 1.0, 1.0);
		glPopMatrix();

		glPushMatrix();
			glTranslated(7.5,-17.0,0.0);
			glRotated(180.0,0.0,1.0,0.0);
			Draw_Rectangle(0.0, 0.0, 17.0, 17.0, "x", 0, tex_tabl, 1.0, 1.0);
		glPopMatrix();

		glPushMatrix();
			glEnable(GL_NORMALIZE);
			glEnable(GL_TEXTURE_2D);
			glBindTexture(GL_TEXTURE_2D, tex_tabl);
			gluQuadricDrawStyle(glQ, GLU_FILL);
			gluQuadricNormals(glQ,  GLU_SMOOTH);
			gluQuadricOrientation(glQ,  GLU_OUTSIDE);
			gluQuadricTexture(glQ, GL_TRUE);
			glTranslated(0.0,0.0,-15.0);
			glRotated(180.0,0.0,1.0,0.0);
			glRotated(90.0, 1.0, 0.0, 0.0);
			glClipPlane(GL_CLIP_PLANE0, plane);
			glEnable(GL_CLIP_PLANE0);
			gluCylinder(glQ, 7.5, 7.5, 17.0, 60.0, 60.0);
			glDisable(GL_CLIP_PLANE0);
		glPopMatrix();

		glPushMatrix();
			glTranslated(-7.525, -2.0, -22.5);
			Draw_Rectangle(0.0,0.0, 2.0,30.0, "x", 1, tex_topTable, 1.0, 1.0);
		glPopMatrix();

		glPushMatrix();
			glTranslated(7.525, -2.0, 7.5);
			glRotated(180.0, 0.0, 1.0, 0.0);
			Draw_Rectangle(0.0,0.0, 2.0,30.0, "x", 1, tex_topTable, 1.0, 1.0);
		glPopMatrix();

			glPushMatrix();
			glTranslated(-7.525, -2.0, -22.5);
			Draw_Rectangle(0.0,0.0, 15.0,2.0, "z", 1, tex_topTable, 1.0, 1.0);
		glPopMatrix();

		glPushMatrix();
			glTranslated(7.525, -2.0, 7.5);
			glRotated(180.0, 0.0, 1.0, 0.0);
			Draw_Rectangle(0.0,0.0, 15.0,2.0, "z", 1, tex_topTable, 1.0, 1.0);
		glPopMatrix();


		glPushMatrix();
		glTranslated(-7.5, 0.0, -22.5);
			Draw_Rectangle(0.0,0.0, 15.5,30, "y", 1, tex_topTable, 1.0, 1.0);
		glPopMatrix();
	glPopMatrix();
}

void Scene::Draw_Table(unsigned int texture_number){
	glDisable(GL_CULL_FACE);
	glPushMatrix();
	glTranslated(0.0,-1.5,0.0);
	glPushMatrix();
		Draw_Rectangle(0.0,0.0,15.0,15.0, "y", 0, texture_number, 1.0, 1.0);
		glPushMatrix();
		glTranslated(0.0,1.5,0.0);
		Draw_Rectangle(0.0,0.0,15.0,15.0, "y", 1, texture_number, 1.0, 1.0);
		glPopMatrix();
		Draw_Rectangle(0.0,0.0,15.0,1.5, "z", 0, texture_number, 1.0, 1.0);
		glPushMatrix();
		glTranslated(0.0,0.0,15.0);
		Draw_Rectangle(0.0,0.0,15.0,1.5, "z", 1, texture_number, 1.0, 1.0);
		glPopMatrix();
		Draw_Rectangle(0.0,0.0,1.5,15.0, "x", 0, texture_number, 1.0, 1.0);
		glPushMatrix();
		glTranslated(15.0,0.0,0.0);
		Draw_Rectangle(0.0,0.0,1.5,15.0, "x", 1, texture_number, 1.0, 1.0);
		glPopMatrix();

		glPushMatrix();
			Draw_LegTable(texture_number);
		glPopMatrix();

		glPushMatrix();
			glTranslated(13.5,0.0,13.5);
			Draw_LegTable(texture_number);
		glPopMatrix();

		glPushMatrix();
			glTranslated(13.5,0.0,0.0);
			Draw_LegTable(texture_number);
		glPopMatrix();

		glPushMatrix();
			glTranslated(0.0,0.0,13.5);
			Draw_LegTable(texture_number);
		glPopMatrix();
	glPopMatrix();

	glPopMatrix();
	glEnable(GL_CULL_FACE);
}