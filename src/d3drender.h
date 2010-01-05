/*

	PROJECT:		m0d_s0beit_sa
	LICENSE:		See LICENSE in the top level directory
	COPYRIGHT:		Copyright 2007, 2008, 2009, 2010 we_sux

	m0d_s0beit_sa is available from http://code.google.com/p/m0d-s0beit-sa/

	m0d_s0beit_sa is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	m0d_s0beit_sa is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with m0d_s0beit_sa.  If not, see <http://www.gnu.org/licenses/>.

	$LastChangedDate: 2009-12-14 01:12:56 -0600 (Mon, 14 Dec 2009) $
	$LastChangedBy: futnucks $
	$Revision: 31 $
	$HeadURL: https://m0d-s0beit-sa.googlecode.com/svn/trunk/src/d3drender.h $
	$Id: d3drender.h 31 2009-12-14 07:12:56Z futnucks $

*/

#ifndef _D3DRENDER_H
#define _D3DRENDER_H

class CD3DFont;
class CD3DRender;

#define FCR_NONE     0x0
#define FCR_BOLD     0x1
#define FCR_ITALICS  0x2
#define FCR_BORDER   0x4

//FVF Macros
#define D3DFVF_BITMAPFONT   (D3DFVF_XYZRHW|D3DFVF_DIFFUSE|D3DFVF_TEX1)
#define D3DFVF_PRIMITIVES   (D3DFVF_XYZRHW|D3DFVF_DIFFUSE)

typedef struct d3dvertex_s { float x,y,z,rhw; DWORD color; float tu,tv; } d3dvertex_s;

//Initialization Macros
#undef SAFE_RELEASE
#define SAFE_RELEASE(d) if(d) { d->Release(); d=NULL; }

class CD3DBaseRender
{
public:
   CD3DBaseRender();
   ~CD3DBaseRender();

   static HRESULT BeginRender();
   static HRESULT EndRender();

protected:
   static HRESULT Initialize(IDirect3DDevice9 *pD3Ddev);
   static HRESULT Invalidate();

   static HRESULT CreateStates();
   static HRESULT DeleteStates();

   static IDirect3DDevice9       *m_pD3Ddev;
   static IDirect3DStateBlock9   *m_pD3DstateDraw;
   static IDirect3DStateBlock9   *m_pD3DstateNorm;

   static int  m_renderCount;
   static int  m_numShared;
   static bool m_statesOK;
};

class CD3DFont : public CD3DBaseRender
{
public:
   CD3DRender *m_pRender;

   CD3DFont(const char *szFontName, int fontHeight, DWORD dwCreateFlags);
   ~CD3DFont();

   HRESULT Initialize(IDirect3DDevice9 *pD3Ddev);
   HRESULT Invalidate();

   HRESULT Print(float x, float y, DWORD color, const char *szText);
   HRESULT PrintShadow(float x, float y, DWORD color, const char *szText);

   float DrawLength(const char*) const;
   float DrawHeight() const { return m_fChrHeight; };

private:   
   HRESULT CreateVertexBuffers();
   HRESULT DeleteVertexBuffers();

   char  m_szFontName[31+1];
   int   m_fontHeight;
   DWORD m_dwCreateFlags;

   bool  m_isReady;

   IDirect3DTexture9       *m_pD3Dtex;
   IDirect3DVertexBuffer9  *m_pD3Dbuf;

   DWORD m_maxTriangles;

   int   m_texWidth, m_texHeight;
   int   m_chrSpacing;
   float m_fTexCoords[224][4];
   float m_fChrHeight;
};

class CD3DRender : public CD3DBaseRender
{
public:
   CD3DRender(int numVertices);
   ~CD3DRender();

   HRESULT Initialize(IDirect3DDevice9 *pD3Ddev);
   HRESULT Invalidate();

   HRESULT Begin(D3DPRIMITIVETYPE primType);
   HRESULT End();

   HRESULT D3DColor(DWORD color);
   void D3DBindTexture(IDirect3DTexture9 *);
   void D3DTexCoord2f(float u, float v);
   HRESULT D3DVertex2f(float x, float y);

   void D3DTexQuad(float sx, float sy, float ex, float ey, float su, float sv, float eu, float ev);
   void D3DBox(float x, float y, float w, float h, D3DCOLOR color);
   void D3DBoxi(int x, int y, int w, int h, D3DCOLOR color, int maxW);
   void D3DBoxBorder(float x, float y, float w, float h, D3DCOLOR border_color, D3DCOLOR color);
   void D3DBoxBorderi(int x, int y, int w, int h, D3DCOLOR border_color, D3DCOLOR color);

private:
   D3DPRIMITIVETYPE        m_primType;
   IDirect3DVertexBuffer9  *m_pD3Dbuf;
   d3dvertex_s             *m_pVertex;

   DWORD m_color;
   float m_tu, m_tv;
   IDirect3DTexture9 *m_texture;
   int   m_maxVertex;
   int   m_curVertex;

   bool  m_canRender;
};

#endif