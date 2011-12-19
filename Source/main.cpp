/****************************************************************/
/*					LAIG - Third Project			            */
/*																*/
/*																*/
/*			Damien Rosa					Tiago Cruzeiro			*/
/*				ei09093						ei09044				*/
/*																*/
/*																*/
/****************************************************************/

#pragma once

#include <GL\glui.h>
#include <math.h>
#include <iostream>
#include <string>
#include "RGBpixmap.h"
#include "LaigToProlog.h"
#include "piece_bishop.h"
#include "Scene.h"
#include <time.h>

using namespace std;

// Window dimensions and position
#define DIMX 750
#define DIMY 500
#define INITIALPOS_X 200
#define INITIALPOS_Y 200

// Variables
float xy_aspect;
int wireframe = 0;
int freeRoam = 0;
Scene scene;

// Auxiliary matrix for the rotation button
float view_rotate[16] =	{1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1};

// Auxiliary vector used by the zoom button
float obj_pos[] = { 0.0, 0.0, 0.0 };

//Tabuleiro
int sizeBoard = 8;

// Default material properties
float mat1_shininess[] = {128.0}; 
float mat1_specular[] = {0.4, 0.4, 0.4, 1.0};	/* specular reflection. */
float mat1_diffuse[] =  {0.6, 0.6, 0.6, 1.0};	/* diffuse reflection. */
float mat1_ambient[] =  {0.6, 0.6, 0.6, 1.0};	/* ambient reflection. */
double dimx = 6.0;
double dimy = 2.0;
double dimz = 10.0;

float light0_kc = 0.0;
float light0_kl = 0.0;
float light0_kq = 0.1;

// LIGHT0 declarations;
float light0_position[]  = {0.0, 3.0, 0.0, 1.0}; 
float light0_ambient[] =   {0.0, 0.0, 0.0, 1.0};
float light0_diffuse[] =   {0.8, 0.8, 0.8, 1.0};
float light0_specular[] =  {0.8, 0.8, 0.8, 1.0};
double light0x = dimx/2.0;
double light0y = 1;
double light0z = dimz/4.0;
double symb_light0_radius = 0.2;	//Declarations for the Light0 sphere
int symb_light0_slices = 8;			
int symb_light0_stacks =16;			

// Background ambient lighting
float light_ambient[] = {0.2, 0.2, 0.2, 1.0};

// Window variables
int main_window;
GLUI  *glui2;
GLUquadric* glQ;
GLUI_Translation *trans_xy;
GLUI_Rotation *view_rot;
GLUI_Translation *trans_z;
GLUI_Checkbox *check;

#define IPADDRESS "127.0.0.1"
#define PORT "60070"

vector<string> board;

// Picking
#define BUFSIZE 512
GLuint selectBuf[BUFSIZE];
unsigned int n = 0;

SOCKET *ms;

// Pixmap for the textures
RGBpixmap pixmap;

// Camera
int camera = 1; // 1 for perspective view, 2 for top view, 3 for player 1 view, 4 for player 2 view

// Scene texture vars
int scene_texture = 1;
int floor_texture = 2;
int table_texture = 1;
int black_cell_texture = 5;
int white_cell_texture = 4;

struct g_mouseState{
	bool leftButton;
	bool rightButton;
	bool middleButton;
	int x;
	int y;
} MouseState;

void LoadDefaultMaterials()
{
	// Default material properties
	glMaterialfv(GL_FRONT, GL_SHININESS, mat1_shininess);
	glMaterialfv(GL_FRONT, GL_SPECULAR,  mat1_specular);
	glMaterialfv(GL_FRONT, GL_DIFFUSE,   mat1_diffuse);
	glMaterialfv(GL_FRONT, GL_AMBIENT,   mat1_ambient);
}

void scene_texture_change(){
	if (scene_texture==1){
		floor_texture = 2;
		table_texture = 1;
		black_cell_texture = 5;
		white_cell_texture = 4;}
	else if(scene_texture==2){
		floor_texture = 8;
		table_texture = 9;
		black_cell_texture = 6;
		white_cell_texture = 7;}
}

void BoardInicialize(){
    string question = "initialize.\n";
    char* s = new char [question.size()];
    strcpy(s, question.c_str());
    sendMessage(s, question.size());
    char ans[500];
    receiveMessage(ans);
    readBoardCheck(ans, board);
}

void animated(int x, int y, int newy, int newx){
}

void Draw_Scene(GLenum mode){

	//glFrustum(-xy_aspect*.1, xy_aspect*.1, -0.1, 0.1, .1, 50.0);
	glFrustum(-xy_aspect*.04, xy_aspect*.04, -.04, .04, .08, 500.0);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	//glTranslated(0.0,0.0,-25.0);
	//glTranslatef(obj_pos[0], obj_pos[1], -obj_pos[2]);
	//glRotated(20.0, 1.0,0.0,0.0);
	//glRotated(-45.0, 0.0,1.0,0.0);
	//glMultMatrixf(view_rotate);

	scene_texture_change();
	 unsigned int l = 1;

	if(camera == 1){ 
		glTranslated(0.0,0.0,-25.0);
		glTranslatef(obj_pos[0], obj_pos[1], -obj_pos[2]);
        glRotated(20.0, 1.0,0.0,0.0);
		glRotated(-45.0, 0.0,1.0,0.0);
        glMultMatrixf(view_rotate);
	}
		else if(camera == 2){
			gluLookAt(2.0, 15.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
		}
			else if(camera == 3){
				gluLookAt(0.0, 15.0, 10.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
			}
				else if(camera == 4){
					gluLookAt(0.0, 15.0, -10.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
				}

	glPushMatrix();
    glPushMatrix();
    glPushMatrix();
    glTranslated(0.0,-16.5,0.0);
    scene.Draw_Floor(floor_texture);
    glPopMatrix();
    glTranslated(-5.0,0.0,-6.0);
    scene.Draw_Board();
    int tex = 0;
    for(int i = 0; i < sizeBoard; i++){
                                
        glTranslatef(-sizeBoard,0.0,1.0);
        for(int j = 0; j < sizeBoard; j++){        
            if((i%2) == 0){
                    if(j%2 == 0) tex=white_cell_texture;
                    else tex=black_cell_texture;
            } else {
                    if(j%2 == 0) tex=black_cell_texture;
                    else tex=white_cell_texture;
            }
                                                
            glTranslatef(1.0,0.0,0.0);
            if(mode == GL_SELECT){
                    glPushName(l);
            }
            scene.Draw_PositionBoard(tex);
            if(mode == GL_SELECT){
                    glPopName();
            }
            if(mode == GL_SELECT){
                    l++;
            }
        }
    }
    glPopMatrix();
    glPopMatrix();
                
    glPushMatrix();
        glTranslated(-7.5,0.0,-7.5);
        scene.Draw_Table(table_texture);
    glPopMatrix();

    glPushMatrix();
    glTranslated(-3.5,1.6,3.5);
    scene.Draw_Pieces();
    glPopMatrix();

    glPopMatrix();

}

void display(void){

	glQ = gluNewQuadric();

	// Necessary initializations for the tranformation buttons, default view, etc
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	//glFrustum(-xy_aspect*.1, xy_aspect*.1, -0.1, 0.1, .1, 50.0);
	/*glFrustum(-xy_aspect*.04, xy_aspect*.04, -.04, .04, .08, 500.0);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glTranslated(0.0,0.0,-25.0);
	glTranslatef(obj_pos[0], obj_pos[1], -obj_pos[2]);
	glRotated(20.0, 1.0,0.0,0.0);
	glRotated(-45.0, 0.0,1.0,0.0);
	glMultMatrixf(view_rotate);*/

	// Activate the freeroaming buttons according to the user choice
	if (freeRoam){
		view_rot->enable();
		trans_z->enable();
		trans_xy->enable();
	}else {
		view_rot->disable();
		trans_z->disable();
		trans_xy->disable();
	}

	glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);
	glEnable(GL_COLOR_MATERIAL);

	gluQuadricOrientation(glQ, GLU_OUTSIDE);

	LoadDefaultMaterials();


	//scene.Draw_Axis(glQ);


	glDisable(GL_COLOR_MATERIAL);
	LoadDefaultMaterials();

	Draw_Scene(GL_RENDER);

	glutSwapBuffers();
	glFlush();
}
	
void pickingAction(GLuint answer) {
	// Prints the picking action
	printf("%d\n", answer);
}

void processHits (GLint hits, GLuint buffer[]) {

	GLuint *ptr = buffer;
	GLuint mindepth = 0xFFFFFFFF;
	GLuint *answer=NULL;
	GLuint nn;

	for (int i=0;i<hits;i++) {
		int num = *ptr; ptr++;
		GLuint z1 = *ptr; ptr++;
		ptr++;
		if (z1 < mindepth && num>0) {
			mindepth = z1;
			answer = ptr;
			nn=num;
		}
		for (int j=0; j < num; j++) 
			ptr++;
	}

	if (answer!=NULL) {
		pickingAction(*answer);
	}
}

void processMouse(int button, int state, int x, int y) {
    GLint hits;
	GLint viewport[4];

	// update our button state
	if(button == GLUT_LEFT_BUTTON) {
		if(state == GLUT_DOWN)
			MouseState.leftButton = true;
		else
			MouseState.leftButton = false;
	}
	if(button == GLUT_RIGHT_BUTTON) {
		if(state == GLUT_DOWN)
			MouseState.rightButton = true;
		else
			MouseState.rightButton = false;
	}
	if(button == GLUT_MIDDLE_BUTTON) {
		if(state == GLUT_DOWN)
			MouseState.middleButton = true;
		else
			MouseState.middleButton = false;
	}

	// update our position so we know a delta when the mouse is moved
	MouseState.x = x;
	MouseState.y = y;
	
	if (MouseState.leftButton && !MouseState.rightButton && !MouseState.middleButton) {
		/* obrigatorio para o picking */
		// obter o viewport actual
		glGetIntegerv(GL_VIEWPORT, viewport);

		glSelectBuffer (BUFSIZE, selectBuf);
		glRenderMode (GL_SELECT);

		// inicia processo de picking
		glInitNames();
		glMatrixMode (GL_PROJECTION);
		glPushMatrix ();

		//  cria uma região de 5x5 pixels em torno do click do rato para o processo de picking
		glLoadIdentity ();
		gluPickMatrix ((GLdouble) x, (GLdouble) (DIMY - y), 1.0, 1.0, viewport);

		Draw_Scene(GL_SELECT);

		glMatrixMode (GL_PROJECTION);
		glPopMatrix ();
		glFlush ();

		hits = glRenderMode(GL_RENDER);
		processHits(hits, selectBuf);
	}
}

void processMouseMoved(int x, int y)
{
	//glutPostRedisplay();
}

void processPassiveMouseMoved(int x, int y)
{
	glutPostRedisplay();				
}

void reshape(int w, int h)
{
	int tx, ty, tw, th;

	GLUI_Master.get_viewport_area( &tx, &ty, &tw, &th );
	glViewport( tx, ty, tw, th );
	xy_aspect = (float)tw / (float)th;

	glutPostRedisplay();
}

void keyboard(unsigned char key, int x, int y)
{
   switch (key) {
      case 27:		// esc key exits the program
         exit(0);
         break;
   }
}

void myGlutIdle( void )
{
  /* According to the GLUT specification, the current window is 
     undefined during an idle callback.  So we need to explicitly change
     it if necessary */
  if ( glutGetWindow() != main_window ) 
    glutSetWindow(main_window);  

  glutPostRedisplay();

  /****************************************************************/
  /*            This demonstrates GLUI::sync_live()               */
  /*   We change the value of a variable that is 'live' to some   */
  /*   control.  We then call sync_live, and the control          */
  /*   associated with that variable is automatically updated     */
  /*   with the new value.  This frees the programmer from having */
  /*   to always remember which variables are used by controls -  */
  /*   simply change whatever variables are necessary, then sync  */
  /*   the live ones all at once with a single call to sync_live  */
  /****************************************************************/

  //glui->sync_live();
}

void initialization()
{

	BoardInicialize();

	glFrontFace(GL_CCW);		/* Front faces defined using a counterclockwise rotation. */
	glDepthFunc(GL_LEQUAL);		/* Por defeito e GL_LESS */
	glEnable(GL_DEPTH_TEST);	/* Use a depth (z) buffer to draw only visible objects. */
	glEnable(GL_CULL_FACE);		/* Use face culling to improve speed. */
	glCullFace(GL_BACK);		/* Cull only back faces. */
	
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	glEnable(GL_NORMALIZE);

	glShadeModel(GL_SMOOTH);				// GL_FLAT / GL_SMOOTH

	//Textures

	pixmap.readBMPFile("Resources/Brown-fine-wood-texture.bmp");
	pixmap.setTexture(1);

	pixmap.readBMPFile("Resources/carpet.bmp");
	pixmap.setTexture(2);

	pixmap.readBMPFile("Resources/marble_black.bmp");
	pixmap.setTexture(3);
	
	pixmap.readBMPFile("Resources/piece_white.bmp");
	pixmap.setTexture(4);
	
	pixmap.readBMPFile("Resources/piece_black.bmp");
	pixmap.setTexture(5);

	pixmap.readBMPFile("Resources/marble_blue.bmp");
	pixmap.setTexture(6);

	pixmap.readBMPFile("Resources/marble_red.bmp");
	pixmap.setTexture(7);

	pixmap.readBMPFile("Resources/lava.bmp");
	pixmap.setTexture(8);

	pixmap.readBMPFile("Resources/stone.bmp");
	pixmap.setTexture(9);


	// compile the display list, store a triangle in it

		

}

void wireframeControl(int d){
	if(wireframe)
		glPolygonMode(GL_FRONT, GL_LINE );
	else
		glPolygonMode(GL_FRONT, GL_FILL);
}

void f(){
	quit();
}

int main(int argc, char* argv[]){

	socketConnect(IPADDRESS, PORT);
	atexit(f);
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
	glutInitWindowSize (DIMX, DIMY);
	glutInitWindowPosition (INITIALPOS_X, INITIALPOS_Y);
	main_window = glutCreateWindow (argv[0]);
 
	glutDisplayFunc(display);
	GLUI_Master.set_glutReshapeFunc(reshape);
	GLUI_Master.set_glutKeyboardFunc (keyboard);
	GLUI_Master.set_glutMouseFunc(processMouse);
	glutMotionFunc(processMouseMoved);
	glutPassiveMotionFunc(processPassiveMouseMoved);   
	GLUI_Master.set_glutSpecialFunc(NULL);
   
	/*** Create the bottom subwindow ***/
	glui2 = GLUI_Master.create_glui_subwindow(main_window, GLUI_SUBWINDOW_BOTTOM);
	glui2->set_main_gfx_window(main_window);

	view_rot = glui2->add_rotation("Rotacao", view_rotate);
	view_rot->set_spin(1.0);
	glui2->add_column(false);

	trans_z = glui2->add_translation("Zoom", GLUI_TRANSLATION_Z, &obj_pos[2]);
	trans_z->set_speed(.02);

	glui2->add_column(false);	

	trans_xy = glui2->add_translation("Pan", GLUI_TRANSLATION_XY, &obj_pos[0]);

	glui2->add_column(false);	

	glui2->add_checkbox("Wireframe",&wireframe,1,wireframeControl);
	glui2->add_checkbox("FreeRoam",&freeRoam,-1,NULL);
	glui2->add_column(false);

	GLUI_Listbox *listbox = glui2->add_listbox("Cameras",&camera,-1,NULL);
	listbox->add_item(1,"Perspective");
	listbox->add_item(2,"Top View");
	listbox->add_item(3,"Player 1 View");
	listbox->add_item(4,"Player 2 View");
	listbox->set_int_val(2);
	glui2->add_column(false);

	GLUI_Listbox *listbox_2 = glui2->add_listbox("Scenes",&scene_texture,-1,NULL);
	listbox_2->add_item(1,"Scene 1");
	listbox_2->add_item(2,"Scene 2");
	listbox_2->set_int_val(1);
	glui2->add_column(false);


	/* We register the idle callback with GLUI, not with GLUT */
	GLUI_Master.set_glutIdleFunc( myGlutIdle );
   
	initialization();

	glutMainLoop();

	return 0;
}