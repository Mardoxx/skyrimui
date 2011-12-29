class BookMenu extends MovieClip
{
	static var PAGE_BREAK_TAG: String = "[pagebreak]";
	static var NOTE_WIDTH: Number = 400;
	static var NOTE_X_OFFSET: Number = 20;
	static var NOTE_Y_OFFSET: Number = 10;
	static var CACHED_PAGES: Number = 4;
	static var BookMenuInstance: Object;
	var BookPages: Array;
	var PageInfoA: Array;
	var RefTextFieldTextFormat: TextField;
	var ReferenceTextField: TextField;
	var ReferenceTextInstance: TextField;
	var ReferenceText_mc: TextField
	var bNote: Boolean;
	var iCurrentLine: Number;
	var iLeftPageNumber: Number;
	var iMaxPageHeight: Number;
	var iNextPageBreak: Number;
	var iPageSetIndex: Number;
	var iPaginationIndex: Number;

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

	function onLoad(): Void
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

	function SetBookText(astrText: String, abNote: Boolean): Void
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

	function CreateDisplayPage(PageTop: Number, PageBottom: Number, aPageNum: Number): Void
	{
		var Page_mc: MovieClip = this.ReferenceText_mc.duplicateMovieClip("Page", this.getNextHighestDepth());
		var PageTextField: TextField = Page_mc.PageTextField;
		PageTextField.noTranslate = true;
		PageTextField.SetText(this.ReferenceTextField.htmlText, true);
		var iLineOffsetTop: Number = this.ReferenceTextField.getLineOffset(this.ReferenceTextField.getLineIndexAtPoint(0, PageTop));
		var iLineOffsetBottom: Number = this.ReferenceTextField.getLineOffset(this.ReferenceTextField.getLineIndexAtPoint(0, PageBottom));
		PageTextField.replaceText(0, iLineOffsetTop, "");
		PageTextField.replaceText(iLineOffsetBottom - iLineOffsetTop, this.ReferenceTextField.length, "");
		PageTextField.autoSize = "left";
		if (this.bNote) 
		{
			PageTextField._width = BookMenu.NOTE_WIDTH;
			Page_mc._x = Stage.visibleRect.x + BookMenu.NOTE_X_OFFSET;
			Page_mc._y = Stage.visibleRect.y + BookMenu.NOTE_Y_OFFSET;
		}
		else 
		{
			Page_mc._x = this.ReferenceText_mc._x;
			Page_mc._y = this.ReferenceText_mc._y;
		}
		Page_mc._visible = false;
		Page_mc.pageNum = aPageNum;
		this.BookPages.push(Page_mc);
	}

	function CalculatePagination(): Void
	{
		var bLastPage: Boolean = false;
		while (!bLastPage && this.iCurrentLine <= this.ReferenceTextField.numLines) 
		{
			var iLineOffsetCurrent: Number = this.ReferenceTextField.getLineOffset(this.iCurrentLine);
			var iLineOffsetNext: Number  = this.ReferenceTextField.getLineOffset(this.iCurrentLine + 1);
			var acharBoundaries: Object = this.ReferenceTextField.getacharBoundaries(iLineOffsetCurrent);
			var astrPageText: String = iLineOffsetNext == -1 ? this.ReferenceTextField.text.substring(iLineOffsetCurrent ) : this.ReferenceTextField.text.substring(iLineOffsetCurrent, iLineOffsetNext);
			astrPageText = Shared.GlobalFunc.StringTrim(astrPageText);
			if (acharBoundaries.bottom > this.iNextPageBreak || astrPageText == BookMenu.PAGE_BREAK_TAG || this.iCurrentLine >= this.ReferenceTextField.numLines) 
			{
				var aPageDims: Object = {pageTop: 0, pageHeight: this.iMaxPageHeight};
				if (astrPageText == BookMenu.PAGE_BREAK_TAG) 
				{
					aPageDims.pageTop = acharBoundaries.bottom + this.ReferenceTextField.getLineMetrics(this.iCurrentLine).leading;
					this.PageInfoA[this.PageInfoA.length - 1].pageHeight = acharBoundaries.top - this.PageInfoA[this.PageInfoA.length - 1].pageTop;
				}
				else 
				{
					aPageDims.pageTop = acharBoundaries.top;
					this.PageInfoA[this.PageInfoA.length - 1].pageHeight = aPageDims.pageTop - this.PageInfoA[this.PageInfoA.length - 1].pageTop;
				}
				this.iNextPageBreak = aPageDims.pageTop + this.iMaxPageHeight;
				if (aPageDims.pageTop != undefined || this.bNote) 
				{
					this.PageInfoA.push(aPageDims);
				}
				bLastPage = true;
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

	function SetLeftPageNumber(aiPageNum: Number): Void
	{
		if (aiPageNum < this.PageInfoA.length) 
		{
			this.iLeftPageNumber = aiPageNum;
		}
	}

	function ShowPageAtOffset(aiPageOffset: Number): Void
	{
		var iPageNumber: Number = 0;
		for (;;) 
		{
			if (iPageNumber >= this.BookPages.length) 
			{
				return;
			}
			if (this.BookPages[iPageNumber].pageNum == this.iPageSetIndex + aiPageOffset) 
			{
				this.BookPages[iPageNumber]._visible = true;
			}
			else 
			{
				this.BookPages[iPageNumber]._visible = false;
			}
			++iPageNumber;
		}
	}

	function PrepForClose(): Void
	{
		this.iPageSetIndex = this.iLeftPageNumber;
	}

	function TurnPage(aiDelta: Number): Boolean
	{
		var iNewPageNumber: Number = this.iLeftPageNumber + aiDelta;
		var bValidTurn: Boolean = iNewPageNumber >= 0 && iNewPageNumber < this.PageInfoA.length;
		if (this.bNote) 
		{
			bValidTurn = iNewPageNumber >= 0 && iNewPageNumber < this.PageInfoA.length - 1;
		}
		var iPagestoTurn: Number = Math.abs(aiDelta);
		if (bValidTurn) 
		{
			var iUnknown: Number = iPagestoTurn == 1 ? 1 : 4; // Unknown variable
			this.SetLeftPageNumber(iNewPageNumber);
			if (this.iLeftPageNumber < this.iPageSetIndex) 
			{
				this.iPageSetIndex = this.iPageSetIndex - iPagestoTurn;
			}
			else if (this.iLeftPageNumber >= this.iPageSetIndex + iUnknown) 
			{
				this.iPageSetIndex = this.iPageSetIndex + iPagestoTurn;
			}
			this.UpdatePages();
		}
		return bValidTurn;
	}

	function UpdatePages(): Void
	{
		var iCachedPage: Number = 0;
		while (iCachedPage < BookMenu.CACHED_PAGES) 
		{
			var bUnknown: Boolean = false; // Unknown Boolean
			var iCurrentPage: Number = 0;
			while (!bUnknown && iCurrentPage < this.BookPages.length) 
			{
				if (this.BookPages[iCurrentPage].pageNum == this.iPageSetIndex + iCachedPage) 
				{
					bUnknown = true;
				}
				++iCurrentPage;
			}
			if (!bUnknown && (this.PageInfoA.length > this.iPageSetIndex + iCachedPage + 1 || (this.iPaginationIndex == -1 && this.PageInfoA.length > this.iPageSetIndex + iCachedPage))) 
			{
				this.CreateDisplayPage(this.PageInfoA[this.iPageSetIndex + iCachedPage].pageTop, this.PageInfoA[this.iPageSetIndex + iCachedPage].pageTop + this.PageInfoA[this.iPageSetIndex + iCachedPage].pageHeight, this.iPageSetIndex + iCachedPage);
			}
			++iCachedPage;
		}
		var iCurrentPage: Number = 0;
		for (;;) 
		{
			if (iCurrentPage >= this.BookPages.length) 
			{
				return;
			}
			if (this.BookPages[iCurrentPage].pageNum < this.iPageSetIndex || this.BookPages[iCurrentPage].pageNum >= this.iPageSetIndex + BookMenu.CACHED_PAGES) 
			{
				this.BookPages.splice(iCurrentPage, 1)[0].removeMovieClip();
			}
			++iCurrentPage;
		}
	}

}
