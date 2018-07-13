/**********����Ϊ��������************/
//ʹ��/**/ע��ѡ�еĴ��룬ֻ֧�ֵ��� Ctrl+Alt+C
macro ChoseStr()
{
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur(hbuf)
    str = GetBufSelText(hbuf)
    len = strlen(str)
 
    if(strmid(str,0,2) != "/*")//���ע��
    {
    	str = cat("/*",str)
	    str = cat(str,"*/")
    }
    else if((strmid(str,0,2) == "/*")&&
    		(strmid(str,len-2,len) == "*/")	)//ɾ��ע��
    {
    	str = strmid(str,2,len-2)   	
    }
    
    SetBufSelText (hbuf, str)
}

//ʹ��/**/ע�͵��� Ctrl+Alt+S
macro SingleLine()
{
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur(hbuf)
	str = GetBufLine (hbuf, ln)
	len = strlen(str)
 
    if(strmid(str,0,2) != "/*")//���ע��
    {
    	str = cat("/*",str)
	    str = cat(str,"*/")
    }
    else if((strmid(str,0,2) == "/*")&&
    		(strmid(str,len-2,len) == "*/")	)//ɾ��ע��
    {
    	str = strmid(str,2,len-2)   	
    }
    
    PutBufLine (hbuf, ln, str)
}

//ʹ��//ע�Ͷ��� Ctrl+Alt+M
macro MultiLineComment()
{
    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    LnFirst =GetWndSelLnFirst(hwnd)      //ȡ�����к�
    LnLast =GetWndSelLnLast(hwnd)      //ȡĩ���к�
    hbuf = GetCurrentBuf()
    if(GetBufLine(hbuf, 0) =="//magic-number:tph85666031")
	{
        stop
    }
    Ln = Lnfirst
    buf = GetBufLine(hbuf, Ln)
    len = strlen(buf)
    while(Ln <= Lnlast) 
	{
        buf = GetBufLine(hbuf, Ln)  //ȡLn��Ӧ����
        if(buf ==""){                   //��������
            Ln = Ln + 1
            continue
    }

	if(StrMid(buf, 0, 1) == "/"){       //��Ҫȡ��ע��,��ֹֻ�е��ַ�����
		if(StrMid(buf, 1, 2) == "/"){
			PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))
		}

	}

	if(StrMid(buf,0,1) !="/"){          //��Ҫ���ע��
		PutBufLine(hbuf, Ln, Cat("//", buf))
	}
	Ln = Ln + 1
    }
    SetWndSel(hwnd, selection)
}

//ʹ��#if 0ע��ѡ�еĶ��д��� Ctrl+Alt+0
macro If0endif_MacroComment()
{
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    lnFirst=GetWndSelLnFirst(hwnd)
    lnLast=GetWndSelLnLast(hwnd)
    hbuf=GetCurrentBuf()
    if (LnFirst == 0) 
	{
		szIfStart = ""
    } 
	else 
	{
		szIfStart = GetBufLine(hbuf, LnFirst-1)
    }

    szIfEnd = GetBufLine(hbuf, lnLast+1)

    if (szIfStart == "#if 0" && szIfEnd =="#endif") 
	{
		DelBufLine(hbuf, lnLast+1)
		DelBufLine(hbuf, lnFirst-1)
		sel.lnFirst = sel.lnFirst - 1
		sel.lnLast = sel.lnLast - 1
    } 
	else 
	{
		InsBufLine(hbuf, lnFirst, "#if 0")
		InsBufLine(hbuf, lnLast+2, "#endif")
		sel.lnFirst = sel.lnFirst + 1
		sel.lnLast = sel.lnLast + 1
    }
    SetWndSel( hwnd, sel )
}

//����ע���ı�������޸�ԭ������ʱ��
macro SingleLineComment()
{
	szMyName = "ycx"
	mdName = "modify"
	// Get a handle to the current file buffer and the name
	// and location of the current symbol where the cursor is.
	hbuf = GetCurrentBuf()
	ln = GetBufLnCur(hbuf)
	 
	// Get current time
	szTime = GetSysTime(1)
	Hour = szTime.Hour
	Minute = szTime.Minute
	Second = szTime.Second
	Day = szTime.Day
	Month = szTime.Month
	Year = szTime.Year
	if (Day < 10)
		szDay = "0@Day@"
	else
		szDay = Day
		
	if (Month < 10)
	     szMonth = "0@Month@"
	else
		szMonth = Month
		
	if (Hour < 10 )
		szHour = "0@Hour@"
	else
		szHour = Hour

	if (Minute < 10 )
		szMinute = "0@Minute@"
	else
		szMinute = Minute
		
	if (Second < 10 )
		szSecond = "0@Second@"
	else
		szSecond = Second
		
	szDescription = Ask("�������޸�ԭ��")
	// begin assembling the title string
	InsBufLine(hbuf, ln+1, "/* @szDescription@ @szMyName@.@mdName@ @Year@-@szMonth@-@szDay@ @szHour@:@szMinute@:@szSecond@ */")
}
 
//�½�һ���ļ�(.c,.cpp,.h)ʱ���ļ�ͷ��ע����Ϣ 
macro MyInsertFileHeader()
{
    LnFirst = 0
    hbuf = GetCurrentBuf()
    fPath = GetBufName(hbuf)//���ص�ǰ�ļ��ľ���·��
    LocalTime = GetSysTime(1)
    szMyName = getenv(MYNAME)
    Year = LocalTime.Year
    Month = LocalTime.Month
    Day = LocalTime.Day
    Time = LocalTime.time

    if (fPath != hNil)
    {
    	fLen = strlen(fPath)
/*        		
        len = fLen
		while (len > 0)//�����ļ�����׺
		{
			if (fPath[len] == ".")
				break
			len = len - 1
		}
		typeName = strmid(fPath, len+1, strlen(fPath))
		suffixLen = strlen(fPath) - len;
		
		len = fLen
		while (len > 0)//�����ļ���ǰ׺
		{
			if (fPath[len] == "\\")
				break
			len = len - 1
		}
		fileName = strmid(fPath, len+1, strlen(fPath)-suffixLen)
*/
		fileName = GetFileNameNoExt(fPath)
		typeName = GetFileNameExt(fPath)
		 		
        if((typeName=="c")||(typeName=="cpp"))
        {
            InsBufLine(hbuf, LnFirst++, "/**")
            InsBufLine(hbuf, LnFirst++, "******************************************************************************")
            InsBufLine(hbuf, LnFirst++, "* \@file\t\t@fileName@.@typeName@") 
            InsBufLine(hbuf, LnFirst++, "* \@author\tBright.Yang @szMyName@")
            InsBufLine(hbuf, LnFirst++, "* \@version\tV1.0")
            InsBufLine(hbuf, LnFirst++, "* \@date\t\t@Year@/@Month@/@Day@ @Time@")
            InsBufLine(hbuf, LnFirst++, "* \@brief\tThis file provides all the @fileName@ functions. ")
            InsBufLine(hbuf, LnFirst++, "******************************************************************************")
            InsBufLine(hbuf, LnFirst++, "* \@attention")
            InsBufLine(hbuf, LnFirst++, "* Copyright (C), 2018-2028, Bright.Yang")
            InsBufLine(hbuf, LnFirst++, "* All rights reserved.")
            InsBufLine(hbuf, LnFirst++, "******************************************************************************")
            InsBufLine(hbuf, LnFirst++, "* \@modified by:\t")
			InsBufLine(hbuf, LnFirst++, "* \@modify info:\t")
            InsBufLine(hbuf, LnFirst++, "* \@date:\t\t")
            InsBufLine(hbuf, LnFirst++, "******************************************************************************")
            InsBufLine(hbuf, LnFirst++, "**/ ")
            InsBufLine(hbuf, LnFirst++, "")
            InsBufLine(hbuf, LnFirst++, "/* Includes ----------------------------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "#include \"@fileName@.h\"")
            InsBufLine(hbuf, LnFirst++, "")
            InsBufLine(hbuf, LnFirst++, "/* Private typedef ---------------------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "/* Private macro -----------------------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "/* Private variables -------------------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "/* Private function prototypes ---------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "/* Private functions -------------------------------------------------------*/"
            InsBufLine(hbuf, LnFirst++, "")
        }
        else if(typeName == "h")
        {
            upperName = toupper(fileName)
            InsBufLine(hbuf, LnFirst++, "/**")
            InsBufLine(hbuf, LnFirst++, "******************************************************************************")
            InsBufLine(hbuf, LnFirst++, "* \@file\t\t@fileName@.h ")
            InsBufLine(hbuf, LnFirst++, "* \@author\tBright.Yang")
            InsBufLine(hbuf, LnFirst++, "* \@version\tV1.0")
            InsBufLine(hbuf, LnFirst++, "* \@date\t\t@Year@/@Month@/@Day@ @Time@")
            InsBufLine(hbuf, LnFirst++, "* \@brief\tThis file contains all the functions prototypes for the @fileName@ ")
            InsBufLine(hbuf, LnFirst++, "******************************************************************************")
            InsBufLine(hbuf, LnFirst++, "* \@attention")
            InsBufLine(hbuf, LnFirst++, "* Copyright (C), 2018-2028, Bright.Yang")
            InsBufLine(hbuf, LnFirst++, "* All rights reserved.")            
            InsBufLine(hbuf, LnFirst++, "******************************************************************************")
            InsBufLine(hbuf, LnFirst++, "* \@modified by:\t")
			InsBufLine(hbuf, LnFirst++, "* \@modify info:\t")
            InsBufLine(hbuf, LnFirst++, "* \@date:\t\t")
            InsBufLine(hbuf, LnFirst++, "******************************************************************************")
            InsBufLine(hbuf, LnFirst++, "**/ ")
            InsBufLine(hbuf, LnFirst++, "")
            InsBufLine(hbuf, LnFirst++, "/* Define to prevent recursive inclusion -----------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "#ifndef __@upperName@_H")
            InsBufLine(hbuf, LnFirst++, "#define __@upperName@_H")
            InsBufLine(hbuf, LnFirst++, "")
            InsBufLine(hbuf, LnFirst++, "#ifdef __cplusplus")
            InsBufLine(hbuf, LnFirst++, "extern \"C\" {")
            InsBufLine(hbuf, LnFirst++, "#endif")
            InsBufLine(hbuf, LnFirst++, "/* Includes ----------------------------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "#include \"includes.h\"")
            InsBufLine(hbuf, LnFirst++, "")
            InsBufLine(hbuf, LnFirst++, "/* Exported typedef --------------------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "/* Exported variables ------------------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "/* Exported macro ----------------------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "/* Exported functions ------------------------------------------------------*/")
            InsBufLine(hbuf, LnFirst++, "")
            InsBufLine(hbuf, LnFirst++, "#ifdef __cplusplus")
            InsBufLine(hbuf, LnFirst++, "}")
            InsBufLine(hbuf, LnFirst++, "#endif")
            InsBufLine(hbuf, LnFirst++, "#endif  /* __@upperName@_H */")
            InsBufLine(hbuf, LnFirst++, "")
        }
    }
} 

//��ȡ�ļ���ǰ׺��������
macro GetFileNameNoExt(sz)
{
    i = 1
    szName = sz
    iLen = strlen(sz)
    j = iLen 
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == ".")
      {
         j = iLen-i 
      }
      if( sz[iLen-i] == "\\" )
      {
         szName = strmid(sz,iLen-i+1,j)
         return szName
      }
      i = i + 1
    }
    szName = strmid(sz,0,j)
    return szName
}

//��ȡ�ļ�����׺��������
macro GetFileNameExt(sz)
{
    i = 1
    j = 0
    szName = sz
    iLen = strlen(sz)
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == ".")
      {
         j = iLen-i 
         szExt = strmid(sz,j + 1,iLen)
         return szExt
      }
      i = i + 1
    }
    return ""
}

//��CreateFuncPrototype����
macro SkipCommentFromString(szLine,isCommentEnd)
{
    RetVal = ""
    fIsEnd = 1
    nLen = strlen(szLine)
    nIdx = 0
    while(nIdx < nLen )
    {
        //�����ǰ�п�ʼ���Ǳ�ע�ͣ���������ע�Ϳ�ʼ�ı��ǣ�ע�����ݸ�Ϊ�ո�?
        if( (isCommentEnd == 0) || (szLine[nIdx] == "/" && szLine[nIdx+1] == "*"))
        {
            fIsEnd = 0
            while(nIdx < nLen )
            {
                if(szLine[nIdx] == "*" && szLine[nIdx+1] == "/")
                {
                    szLine[nIdx+1] = " "
                    szLine[nIdx] = " " 
                    nIdx = nIdx + 1 
                    fIsEnd  = 1
                    isCommentEnd = 1
                    break
                }
                szLine[nIdx] = " "
                
                //����ǵ����ڶ��������һ��Ҳ�϶�����ע����
//                if(nIdx == nLen -2 )
//                {
//                    szLine[nIdx + 1] = " "
//                }
                nIdx = nIdx + 1 
            }    
            
            //����Ѿ�������β��ֹ����
            if(nIdx == nLen)
            {
                break
            }
        }
        
        //�����������//��ע�͵�˵�����涼Ϊע��
        if(szLine[nIdx] == "/" && szLine[nIdx+1] == "/")
        {
            szLine = strmid(szLine,0,nIdx)
            break
        }
        nIdx = nIdx + 1                
    }
    RetVal.szContent = szLine;
    RetVal.fIsEnd = fIsEnd
    return RetVal
}

//��CreateNewHeaderFile����
macro CreateFuncPrototype(hbuf,ln,szType,symbol)
{
    isLastLine = 0
    hOutbuf = GetCurrentBuf()
    szLine = GetBufLine (hbuf,symbol.lnName)
    //ȥ��ע�͵ĸ���
    RetVal = SkipCommentFromString(szLine,fIsEnd)
    szNew = RetVal.szContent
    fIsEnd = RetVal.fIsEnd
    if(strlen(szType)>0)
    {
	    szLine = cat("@szType@ ",szLine)
	    szNew = cat("@szType@ ",szNew)
	}
    sline = symbol.lnFirst     
    while((isLastLine == 0) && (sline < symbol.lnLim))
    {   
        i = 0
        j = 0
        iLen = strlen(szNew)
        while(i < iLen)
        {
            if(szNew[i]=="(")
            {
               j = j + 1;
            }
            else if(szNew[i]==")")
            {
                j = j - 1;
                if(j <= 0)
                {
                    //��������ͷ����
                    isLastLine = 1  
                    //ȥ����������ַ�
        	        szLine = strmid(szLine,0,i+1);
                    szLine = cat(szLine,";")
                    break
                }
            }
            i = i + 1
        }
        InsBufLine(hOutbuf, ln, "@szLine@")
        ln = ln + 1
        sline = sline + 1
        if(isLastLine != 1)
        {              
            //��������ͷ��û�н�����ȡһ��
            szLine = GetBufLine (hbuf, sline)
            szLine = cat("         ",szLine)
            //ȥ��ע�͵ĸ���
            RetVal = SkipCommentFromString(szLine,fIsEnd)
	        szNew = RetVal.szContent
	        fIsEnd = RetVal.fIsEnd
        }                    
    }
    return ln
}

//����������ļ������ߵ�ǰ�ļ����½�һ��.hͷ�ļ�
macro CreateNewHeaderFile()
{
    hbuf = GetCurrentBuf()
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    szName = getreg(MYNAME)
    if(strlen( szName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
    isymMax = GetBufSymCount(hbuf)
    isym = 0
    ln = 0
    //��õ�ǰû�к�׺���ļ���
    sz = ask("Please input header file name:(Input 1 named by the current file name)")
    if(sz == "1")
    {
    	hbuf = GetCurrentBuf()
    	fPath = GetBufName(hbuf)//���ص�ǰ�ļ��ľ���·��    	
    	szFileName = GetFileNameNoExt(fPath)
    	szExt = "h"
    	sz = "@szFileName@.@szExt@"
    } 
    else
    {
		szFileName = GetFileNameNoExt(sz)
	    szExt = GetFileNameExt(sz)        
	}
    szPreH = toupper (szFileName)
    szPreH = cat("__",szPreH)
    szExt = toupper(szExt)
    szPreH = cat(szPreH,"_@szExt@__")
    hOutbuf = NewBuf(sz) // create output buffer
    if (hOutbuf == 0)
        stop

    SetCurrentBuf(hOutbuf)
    MyInsertFileHeader()

    lnMax = GetBufLineCount(hOutbuf)    
    if(lnMax > 6)
    {
        ln = lnMax - 6
    }
    else
    {
        return
    }
    
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    sel.lnFirst = ln
    sel.ichFirst = 0
    sel.ichLim = 0
    SetBufIns(hOutbuf,ln,0)
    szType = Ask ("Please prototype type: 1-extern or 2-static or 3-none")
	if (szType == "1")
	{
		szType = "extern"
	}
	else if(szType == "2")
	{
		szType = "static"
	}
	else 
	{
		szType = ""	
	}	
	//�������ű�ȡ�ú�����
    while (isym < isymMax) 
    {
        isLastLine = 0
        symbol = GetBufSymLocation(hbuf, isym)
        fIsEnd = 1
        if(strlen(symbol) > 0)
        {
            if(symbol.Type == "Class Placeholder")//��Ҫ�޸ģ��ο�quicker.em
	        {
		        hsyml = SymbolChildren(symbol)
				cchild = SymListCount(hsyml)
				ichild = 0
				szClassName = symbol.Symbol
                InsBufLine(hOutbuf, ln, "}")
			    InsBufLine(hOutbuf, ln, "{")
			    InsBufLine(hOutbuf, ln, "class @szClassName@")
			    ln = ln + 2
		    	while (ichild < cchild)
				{
					childsym = SymListItem(hsyml, ichild)
					childsym.Symbol = szClassName
                    ln = CreateClassPrototype(hbuf,ln,childsym)
					ichild = ichild + 1
				}
		        SymListFree(hsyml)
                InsBufLine(hOutbuf, ln + 1, "")
		        ln = ln + 2
	        }
            else if( symbol.Type == "Function" )
            {
                ln = CreateFuncPrototype(hbuf,ln,szType,symbol)
            }
            else if( symbol.Type == "Method" ) //��Ҫ�޸ģ��ο�quicker.em
            {
                szLine = GetBufline(hbuf,symbol.lnName)
                szClassName = GetLeftWord(szLine,symbol.ichName)
                symbol.Symbol = szClassName
                ln = CreateClassPrototype(hbuf,ln,symbol)            
            }
        }
        isym = isym + 1
    }
    sel.lnLast = ln 
    SetWndSel(hwnd,sel)
}

