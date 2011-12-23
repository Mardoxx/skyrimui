dynamic class BookMenu extends MovieClip
{
	static var PAGE_BREAK_TAG: String = "[pagebreak]";
	static var NOTE_WIDTH: Number = 400;
	static var NOTE_X_OFFSET: Number = 20;
	static var NOTE_Y_OFFSET: Number = 10;
	static var CACHED_PAGES: Number = 4;
	var BookPages;
	var PageInfoA;
	var RefTextFieldTextFormat;
	var ReferenceTextField;
	var ReferenceTextInstance;
	var ReferenceText_mc;
	var bNote;
	var getNextHighestDepth;
	var iCurrentLine;
	var iLeftPageNumber;
	var iMaxPageHeight;
	var iNextPageBreak;
	var iPageSetIndex;
	var iPaginationIndex;

	function BookMenu()
	{
		super();
		BookMenu.BookMenuInstance = this;
		this.BookPages = new Array();
		this.PageInfoA = new Array();
		this.iLeftPageNumber = 0;
		this.iPageSetIndex = 0;
		this.bNote = false;
		this.ReferenceText_mc = this.ReferenceTextInstance;
		this.RefTextFieldTextFormat = this.ReferenceText_mc.PageTextField.getTextFormat();
	}

	function onLoad()
	{
		this.ReferenceText_mc._visible = false;
		this.ReferenceTextField = this.ReferenceText_mc.PageTextField;
		this.ReferenceTextField.noTranslate = true;
		this.ReferenceTextField.setTextFormat(this.RefTextFieldTextFormat);
		this.iMaxPageHeight = this.ReferenceTextField._height;
		gfx.io.GameDelegate.addCallBack("SetBookText", this, "SetBookText");
		gfx.io.GameDelegate.addCallBack("TurnPage", this, "TurnPage");
		gfx.io.GameDelegate.addCallBack("PrepForClose", this, "PrepForClose");
	}

	function SetBookText(astrText, abNote)
	{
		this.bNote = abNote;
		this.ReferenceTextField.verticalAutoSize = "top";
		this.ReferenceTextField.SetText(astrText, true);
		if (abNote) 
		{
			this.ReferenceTextField._width = BookMenu.NOTE_WIDTH;
		}
		this.PageInfoA.push({pageTop: 0, pageHeight: this.iMaxPageHeight});
		this.iCurrentLine = 0;
		this.iPaginationIndex = setInterval(this, "CalculatePagination", 30);
		this.iNextPageBreak = this.iMaxPageHeight;
		this.SetLeftPageNumber(0);
	}

	function CreateDisplayPage(PageTop, PageBottom, aPageNum)
	{
		var __reg2 = this.ReferenceText_mc.duplicateMovieClip("Page", this.getNextHighestDepth());
		var __reg3 = __reg2.PageTextField;
		__reg3.noTranslate = true;
		__reg3.SetText(this.ReferenceTextField.htmlText, true);
		var __reg4 = this.ReferenceTextField.getLineOffset(this.ReferenceTextField.getLineIndexAtPoint(0, PageTop));
		var __reg5 = this.ReferenceTextField.getLineOffset(this.ReferenceTextField.getLineIndexAtPoint(0, PageBottom));
		__reg3.replaceText(0, __reg4, "");
		__reg3.replaceText(__reg5 - __reg4, this.ReferenceTextField.length, "");
		__reg3.autoSize = "left";
		if (this.bNote) 
		{
			__reg3._width = BookMenu.NOTE_WIDTH;
			__reg2._x = Stage.visibleRect.x + BookMenu.NOTE_X_OFFSET;
			__reg2._y = Stage.visibleRect.y + BookMenu.NOTE_Y_OFFSET;
		}
		else 
		{
			__reg2._x = this.ReferenceText_mc._x;
			__reg2._y = this.ReferenceText_mc._y;
		}
		__reg2._visible = false;
		__reg2.pageNum = aPageNum;
		this.BookPages.push(__reg2);
	}

	function CalculatePagination()
	{
		var __reg7 = false;
		while (!__reg7 && this.iCurrentLine <= this.ReferenceTextField.numLines) 
		{
			var __reg5 = this.ReferenceTextField.getLineOffset(this.iCurrentLine);
			var __reg6 = this.ReferenceTextField.getLineOffset(this.iCurrentLine + 1);
			var __reg3 = this.ReferenceTextField.getCharBoundaries(__reg5);
			var __reg4 = __reg6 == -1 ? this.ReferenceTextField.text.substring(__reg5) : this.ReferenceTextField.text.substring(__reg5, __reg6);
			__reg4 = Shared.GlobalFunc.StringTrim(__reg4);
			if (__reg3.bottom > this.iNextPageBreak || __reg4 == BookMenu.PAGE_BREAK_TAG || this.iCurrentLine >= this.ReferenceTextField.numLines) 
			{
				var __reg2 = {pageTop: 0, pageHeight: this.iMaxPageHeight};
				if (__reg4 == BookMenu.PAGE_BREAK_TAG) 
				{
					__reg2.pageTop = __reg3.bottom + this.ReferenceTextField.getLineMetrics(this.iCurrentLine).leading;
					this.PageInfoA[this.PageInfoA.length - 1].pageHeight = __reg3.top - this.PageInfoA[this.PageInfoA.length - 1].pageTop;
				}
				else 
				{
					__reg2.pageTop = __reg3.top;
					this.PageInfoA[this.PageInfoA.length - 1].pageHeight = __reg2.pageTop - this.PageInfoA[this.PageInfoA.length - 1].pageTop;
				}
				this.iNextPageBreak = __reg2.pageTop + this.iMaxPageHeight;
				if (__reg2.pageTop != undefined || this.bNote) 
				{
					this.PageInfoA.push(__reg2);
				}
				__reg7 = true;
			}
			++this.iCurrentLine;
		}
		if (this.iCurrentLine >= this.ReferenceTextField.numLines) 
		{
			clearInterval(this.iPaginationIndex);
			this.iPaginationIndex = -1;
		}
		this.UpdatePages();
	}

	function SetLeftPageNumber(aiPageNum)
	{
		if (aiPageNum < this.PageInfoA.length) 
		{
			this.iLeftPageNumber = aiPageNum;
		}
	}

	function ShowPageAtOffset(aiPageOffset)
	{
		var __reg2 = 0;
		for (;;) 
		{
			if (__reg2 >= this.BookPages.length) 
			{
				return;
			}
			if (this.BookPages[__reg2].pageNum == this.iPageSetIndex + aiPageOffset) 
			{
				this.BookPages[__reg2]._visible = true;
			}
			else 
			{
				this.BookPages[__reg2]._visible = false;
			}
			++__reg2;
		}
	}

	function PrepForClose()
	{
		this.iPageSetIndex = this.iLeftPageNumber;
	}

	function TurnPage(aiDelta)
	{
		var __reg2 = this.iLeftPageNumber + aiDelta;
		var __reg4 = __reg2 >= 0 && __reg2 < this.PageInfoA.length;
		if (this.bNote) 
		{
			__reg4 = __reg2 >= 0 && __reg2 < this.PageInfoA.length - 1;
		}
		var __reg3 = Math.abs(aiDelta);
		if (__reg4) 
		{
			var __reg5 = __reg3 == 1 ? 1 : 4;
			this.SetLeftPageNumber(__reg2);
			if (this.iLeftPageNumber < this.iPageSetIndex) 
			{
				this.iPageSetIndex = this.iPageSetIndex - __reg3;
			}
			else if (this.iLeftPageNumber >= this.iPageSetIndex + __reg5) 
			{
				this.iPageSetIndex = this.iPageSetIndex + __reg3;
			}
			this.UpdatePages();
		}
		return __reg4;
	}

	function UpdatePages()
	{
		var __reg2 = 0;
		while (__reg2 < BookMenu.CACHED_PAGES) 
		{
			var __reg4 = false;
			var __reg3 = 0;
			while (!__reg4 && __reg3 < this.BookPages.length) 
			{
				if (this.BookPages[__reg3].pageNum == this.iPageSetIndex + __reg2) 
				{
					__reg4 = true;
				}
				++__reg3;
			}
			if (!__reg4 && (this.PageInfoA.length > this.iPageSetIndex + __reg2 + 1 || (this.iPaginationIndex == -1 && this.PageInfoA.length > this.iPageSetIndex + __reg2))) 
			{
				this.CreateDisplayPage(this.PageInfoA[this.iPageSetIndex + __reg2].pageTop, this.PageInfoA[this.iPageSetIndex + __reg2].pageTop + this.PageInfoA[this.iPageSetIndex + __reg2].pageHeight, this.iPageSetIndex + __reg2);
			}
			++__reg2;
		}
		var __reg5 = 0;
		for (;;) 
		{
			if (__reg5 >= this.BookPages.length) 
			{
				return;
			}
			if (this.BookPages[__reg5].pageNum < this.iPageSetIndex || this.BookPages[__reg5].pageNum >= this.iPageSetIndex + BookMenu.CACHED_PAGES) 
			{
				this.BookPages.splice(__reg5, 1)[0].removeMovieClip();
			}
			++__reg5;
		}
	}

}
