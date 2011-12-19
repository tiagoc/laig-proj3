#pragma once

/***************************************************************************

Base Macros for debugging purpose

	The following macros output information on a specified format, and 
	include source file and line number information.

	Use them directly or through the helper user macros below.

	To disable debug output, comment the DEBUG_MACROS defined below.
	
	To make their use easier, you can define specific types of debug 
	messages as shown below in user macros.
	
***************************************************************************/

#define DEBUG_MACROS

#ifdef DEBUG_MACROS
#define glError(msg) { \
	GLenum err = glGetError(); \
	while (err != GL_NO_ERROR) { \
	fprintf(stderr, "%s: glError: %s caught at %s:%u\n",(msg), (char *)gluErrorString(err), __FILE__, __LINE__); \
		err = glGetError(); \
	} \
}

#define debugMsg(type, msg) \
	fprintf(stderr, "[%s] %s (%s , %u)\n",(type), (msg), __FILE__, __LINE__ ); 
#else

#define glError(msg) 
#define debugMsg(type, msg)

#endif

/***************************************************************************

User Macros. 

	Add your own here, as long as they only use debugMsg, they will be 
	ignored if you disable DEBUG_MACROS above.
	If you want something more elaborate, you should not declare them 
	here, but inside the #ifdef block above, and define an empty equivalent 
	in the #else block above
	
***************************************************************************/

#define debugWarn(msg) debugMsg("WARN",(msg))
#define debugError(msg) debugMsg("ERROR",(msg))

