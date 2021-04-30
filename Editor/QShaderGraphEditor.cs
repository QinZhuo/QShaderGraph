using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Text;
public static  class QShaderGraphEditor
{
    static string CodeBlockAdd(this string code,string blockKey,string addCode)
    {
        var startIndex = code.IndexOf(blockKey);
        var endIndex = code.IndexOf("{",startIndex);
        code = code.Remove(startIndex, endIndex - startIndex + 1);
        code = code.Insert(startIndex,addCode);
        return code;
    }
    [MenuItem("Assets/工具/粘贴生成UIShader",priority = 0)]
    public static void CreateUIShader()
    {
       var window=EditorWindow.GetWindowWithRect<CreateShaderWindow>(new Rect(Screen.width/2-200,Screen.height/2,400,140));
       
        window.Init(Selection.activeObject?.name,(name) =>
        {
            var selectPath = System.IO.Directory.GetParent(AssetDatabase.GetAssetPath(Selection.activeObject)).FullName;
          
            var newFileName = name+".shader";
         
            var newFilePath = selectPath + "/" + newFileName;


            var code = GUIUtility.systemCopyBuffer;
            if (!code.Contains("Properties") && !code.Contains("SubShader"))
            {
                Debug.LogError("粘贴版格式出错" + code);
                return;
            }
            var nameStart= code.IndexOf("Shader \"");
            var nameEnd = code.IndexOf('\"',nameStart+ "Shader \"".Length+1);
            if (nameStart >= 0 && nameEnd > nameStart)
            {
                code = code.Remove(nameStart, nameEnd - nameStart + 1);
                code = code.Insert(nameStart, "Shader \"QShaderGraph/" + name + "\"");
            }
            if (!code.Contains("Stencil Comparison"))
            {

                code = code.CodeBlockAdd("Properties",
        @"Properties
	{
		_StencilComp(""Stencil Comparison"", Float) = 8
        _Stencil(""Stencil ID"", Float) = 0
        _StencilOp(""Stencil Operation"", Float) = 0
        _StencilWriteMask(""Stencil Write Mask"", Float) = 255
        _StencilReadMask(""Stencil Read Mask"", Float) = 255
        _ColorMask(""Color Mask"", Float) = 15");
            }
            if (!code.Contains("ColorMask[_ColorMask]"))
            {
                code = code.CodeBlockAdd("SubShader",
        @"SubShader
	{
		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}
		ColorMask[_ColorMask]");
            }
            if (code.Contains("Blend"))
            {
                var startIndex = code.IndexOf("Blend");
                code = code.Remove(startIndex, code.IndexOf('\n', startIndex) - startIndex);
                code = code.Insert(startIndex, " Blend SrcAlpha OneMinusSrcAlpha");
            }
            //如果是空白文件，编码并没有设成UTF-8
            File.WriteAllText(newFilePath, code, Encoding.UTF8);
            AssetDatabase.Refresh();
            //选中新创建的文件
            var asset = AssetDatabase.LoadAssetAtPath(newFilePath, typeof(Object));
            Selection.activeObject = asset;
        });
       
     
    }
  
}
