// Aaron Lanterman, July 18, 2014
// Cobbled together from numerous sources

using UnityEngine;
using System.Collections;

// based on Texture2D.ReadPixels Unity script reference

public class AdvPostProc : MonoBehaviour {

	public bool process;
	public GameObject depthNormalCamera;

	private Texture2D depthNormalTex;
	private Texture2D originalImageTex;

	public Material postMat; 
	private Vector4[] myLightPosVS;
	private ReplacementShaderCapture rsc;

	// Using a Vector4 because it seems like you can't pass
	// just a Vector2 into a material
	Vector4 cameraData;

	void Start() { 
		depthNormalTex = new Texture2D(Screen.width,Screen.height,TextureFormat.ARGB32,false);
		originalImageTex = new Texture2D(Screen.width,Screen.height,TextureFormat.ARGB32,false);
		rsc = depthNormalCamera.GetComponent<ReplacementShaderCapture>();
	}

	void OnPreRender() {
		cameraData.y = Mathf.Tan(Mathf.Deg2Rad * camera.fieldOfView / 2);   
		cameraData.x = cameraData.y * camera.aspect;
		cameraData.z = camera.farClipPlane - camera.nearClipPlane;
		cameraData.w = camera.nearClipPlane;
	}

	void Update() {
	}

	void OnPostRender() {
		if (process) {
			originalImageTex.ReadPixels(new Rect(0,0,Screen.width,Screen.height),0,0,false);
			originalImageTex.Apply();
			postMat.SetTexture("_EncDepthNormalTex", rsc.capturedTex);
			postMat.SetTexture("_OriginalImageTex", originalImageTex);
			postMat.SetVector("_CameraData",cameraData);

// Raw GL hacking lines from
// http://www.41post.com/4570/programming/unity-how-to-playback-fullscreen-videos-using-the-gl-class
			GL.PushMatrix();  
			postMat.SetPass(0);  
			GL.LoadOrtho();  
			GL.Begin(GL.QUADS);  
			GL.Color(Color.white);  
			GL.TexCoord2(0, 0);  
			GL.Vertex3(0.0f, 0.0f, 0);  
			GL.TexCoord2(0, 1);  
			GL.Vertex3(0.0f, 1f, 0);  
			GL.TexCoord2(1, 1);  
			GL.Vertex3(1f, 1f, 0);  
			GL.TexCoord2(1, 0);  
			GL.Vertex3(1f, 0.0f, 0);  
			GL.End();  
			GL.PopMatrix(); 
		} 
	}
}