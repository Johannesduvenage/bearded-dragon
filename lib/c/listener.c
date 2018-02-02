#include <libwebsockets.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

static struct lws *web_socket = NULL;

#define EXAMPLE_RX_BUFFER_BYTES (10)

static int callback( struct lws *wsi, enum lws_callback_reasons reason, void *user, void *in, size_t len )
{
	switch( reason )
	{
		case LWS_CALLBACK_CLIENT_ESTABLISHED:
			printf("established connection to server\n");
			lws_callback_on_writable( wsi );
			break;

		case LWS_CALLBACK_CLIENT_RECEIVE:
			printf("server said: %s\n", (char*)in);
			break;

		case LWS_CALLBACK_CLIENT_WRITEABLE:
		{
			unsigned char buf[LWS_SEND_BUFFER_PRE_PADDING + EXAMPLE_RX_BUFFER_BYTES + LWS_SEND_BUFFER_POST_PADDING];
			unsigned char *p = &buf[LWS_SEND_BUFFER_PRE_PADDING];
			size_t n = sprintf( (char *)p, "%u", rand() );
			lws_write( wsi, p, n, LWS_WRITE_TEXT );
			break;
		}

		case LWS_CALLBACK_CLOSED:
			printf("closed: %s\n", (char*)in);
		case LWS_CALLBACK_CLIENT_CONNECTION_ERROR:
			printf("error: %s\n", (char*)in);
			web_socket = NULL;
			break;

		default:
			break;
	}

	return 0;
}

enum protocols
{
	PROTOCOL_EXAMPLE = 0,
	PROTOCOL_COUNT
};

static struct lws_protocols protocols[] =
{
	{
		"Gdax-Protocol",
		callback,
		512,
		512,
	},
	{ NULL, NULL, 0, 0 } /* terminator */
};

// int main( int argc, char *argv[] )
int Listen( int argc, char *argv[] )
{
	struct lws_context_creation_info info;
	memset( &info, 0, sizeof(info) );

	info.port = CONTEXT_PORT_NO_LISTEN;
	info.protocols = protocols;
	// lws_set_log_level(65535, NULL);
	lws_set_log_level(LLL_CLIENT, NULL);

	struct lws_context *context = lws_create_context( &info );

	time_t old = 0;
	while( 1 )
	{
		struct timeval tv;
		gettimeofday( &tv, NULL );

		/* Connect if we are not connected to the server. */
		if( !web_socket && tv.tv_sec > old )
		{
			// char * addr = "ws-feed-public.sandbox.gdax.com";
			char * addr = "echo.websocket.org";
			struct lws_client_connect_info ccinfo = {0};
			// ccinfo.ssl_connection = 0;
			ccinfo.context = context;
			ccinfo.address = addr;
			ccinfo.port = 80;
			ccinfo.path = "/";
			ccinfo.host = addr;
			// ccinfo.origin = "http://localhost:80";
			ccinfo.protocol = protocols[PROTOCOL_EXAMPLE].name;
			web_socket = lws_client_connect_via_info(&ccinfo);
		}

		if( tv.tv_sec != old )
		{
			lws_callback_on_writable( web_socket );
			old = tv.tv_sec;
		}

		lws_service( context, /* timeout_ms = */ 2000 );
	}

	lws_context_destroy( context );

	return 0;
}
