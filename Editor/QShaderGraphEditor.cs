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
    [MenuItem("Assets/Create/Shader/QShaderGraph/粘贴生成Shader并支持UIMask")]
    public static void CreateShader()
    {
         var selectPath = AssetDatabase.GetAssetPath(Selection.activeObject);
        var path = Application.dataPath.Replace("Assets", "") + "/";
        var newFileName = "new_shader.shader";
        var newFilePath = selectPath + "/" + newFileName;
        var fullPath = path + newFilePath;


        var code = GUIUtility.systemCopyBuffer;
        if (!code.Contains("Properties") && !code.Contains("SubShader"))
        {
            Debug.LogError("粘贴版格式出错"+code);
            return;
        }
        if(!code.Contains("Stencil Comparison"))
        {
            
            code=code.CodeBlockAdd("Properties",
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
        File.WriteAllText(fullPath, code, Encoding.UTF8);
        AssetDatabase.Refresh();
        //选中新创建的文件
        var asset = AssetDatabase.LoadAssetAtPath(newFilePath, typeof(Object));
        Selection.activeObject = asset;
     
    }
  
}
