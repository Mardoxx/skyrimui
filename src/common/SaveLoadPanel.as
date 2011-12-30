class SaveLoadPanel extends MovieClip
{
	static var SCREENSHOT_DELAY: Number = 750;
	var List_mc: MovieClip;
	var PlayerInfoText: TextField;
	var SaveLoadList_mc: MovieClip;
	var ScreenshotHolder: MovieClip;
	var ScreenshotLoader: MovieClipLoader;
	var ScreenshotRect: MovieClip;
	var bSaving: Boolean;
	var dispatchEvent: Function;
	var iBatchSize: Number;
	var iPlatform: Number;
	var iScreenshotTimerID: Number;

	function SaveLoadPanel()
	{
		super();
		gfx.events.EventDispatcher.initialize(this);
		this.SaveLoadList_mc = this.List_mc;
		this.bSaving = true;
	}

	function onLoad(): Void
	{
		this.ScreenshotLoader = new MovieClipLoader();
		this.ScreenshotLoader.addListener(this);
		gfx.io.GameDelegate.addCallBack("ConfirmOKToLoad", this, "onOKToLoadConfirm");
		gfx.io.GameDelegate.addCallBack("onSaveLoadBatchComplete", this, "onSaveLoadBatchComplete");
		gfx.io.GameDelegate.addCallBack("ScreenshotReady", this, "ShowScreenshot");
		this.SaveLoadList_mc.addEventListener("itemPress", this, "onSaveLoadItemPress");
		this.SaveLoadList_mc.addEventListener("selectionChange", this, "onSaveLoadItemHighlight");
		this.iBatchSize = this.SaveLoadList_mc.maxEntries;
		this.PlayerInfoText.createTextField("LevelText", this.PlayerInfoText.getNextHighestDepth(), 0, 0, 200, 30);
		this.PlayerInfoText.LevelText.text = "$Level";
		this.PlayerInfoText.LevelText._visible = false;
	}

	function get isSaving(): Boolean
	{
		return this.bSaving;
	}

	function set isSaving(abFlag: Boolean)
	{
		this.bSaving = abFlag;
	}

	function get selectedIndex(): Number
	{
		return this.SaveLoadList_mc.selectedIndex;
	}

	function get platform(): Number
	{
		return this.iPlatform;
	}

	function set platform(aiPlatform: Number)
	{
		this.iPlatform = aiPlatform;
	}

	function get batchSize(): Number
	{
		return this.iBatchSize;
	}

	function get numSaves(): Number
	{
		return this.SaveLoadList_mc.entryList.length;
	}

	function onSaveLoadItemPress(event: Object): Void
	{
		if (!this.bSaving) 
		{
			gfx.io.GameDelegate.call("IsOKtoLoad", [this.SaveLoadList_mc.selectedIndex]);
			return;
		}
		this.dispatchEvent({type: "saveGameSelected", index: this.SaveLoadList_mc.selectedIndex});
	}

	function onOKToLoadConfirm(): Void
	{
		this.dispatchEvent({type: "loadGameSelected", index: this.SaveLoadList_mc.selectedIndex});
	}

	function onSaveLoadItemHighlight(event: Object): Void
	{
		if (this.iScreenshotTimerID != undefined) 
		{
			clearInterval(this.iScreenshotTimerID);
			this.iScreenshotTimerID = undefined;
		}
		if (this.ScreenshotRect != undefined) 
		{
			this.ScreenshotRect.removeMovieClip();
			this.PlayerInfoText.textField.SetText(" ");
			this.PlayerInfoText.DateText.SetText(" ");
			this.PlayerInfoText.PlayTimeText.SetText(" ");
			this.ScreenshotRect = undefined;
		}
		if (event.index != -1) 
		{
			this.iScreenshotTimerID = setInterval(this, "PrepScreenshot", SaveLoadPanel.SCREENSHOT_DELAY);
		}
		this.dispatchEvent({type: "saveHighlighted", index: this.SaveLoadList_mc.selectedIndex});
	}

	function PrepScreenshot(): Void
	{
		clearInterval(this.iScreenshotTimerID);
		this.iScreenshotTimerID = undefined;
		if (this.bSaving) 
		{
			gfx.io.GameDelegate.call("PrepSaveGameScreenshot", [this.SaveLoadList_mc.selectedIndex - 1, this.SaveLoadList_mc.selectedEntry]);
			return;
		}
		gfx.io.GameDelegate.call("PrepSaveGameScreenshot", [this.SaveLoadList_mc.selectedIndex, this.SaveLoadList_mc.selectedEntry]);
	}

	function ShowScreenshot(): Void
	{
		this.ScreenshotRect = this.ScreenshotHolder.createEmptyMovieClip("ScreenshotRect", 0);
		this.ScreenshotLoader.loadClip("img://BGSSaveLoadHeader_Screenshot", this.ScreenshotRect);
		if (this.SaveLoadList_mc.selectedEntry.corrupt == true) 
		{
			this.PlayerInfoText.textField.SetText("$SAVE CORRUPT");
		}
		else if (this.SaveLoadList_mc.selectedEntry.obsolete == true) 
		{
			this.PlayerInfoText.textField.SetText("$SAVE OBSOLETE");
		}
		else if (this.SaveLoadList_mc.selectedEntry.name == undefined) 
		{
			this.PlayerInfoText.textField.SetText(" ");
		}
		else 
		{
			var strSaveName: String = this.SaveLoadList_mc.selectedEntry.name;
			var iSaveNameMaxLength: Number = 20;
			if (strSaveName.length > iSaveNameMaxLength) 
			{
				strSaveName = strSaveName.substr(0, iSaveNameMaxLength - 3) + "...";
			}
			if (this.SaveLoadList_mc.selectedEntry.raceName != undefined && this.SaveLoadList_mc.selectedEntry.raceName.length > 0) 
			{
				strSaveName = strSaveName + (", " + this.SaveLoadList_mc.selectedEntry.raceName);
			}
			if (this.SaveLoadList_mc.selectedEntry.level != undefined && this.SaveLoadList_mc.selectedEntry.level > 0) 
			{
				strSaveName = strSaveName + (", " + this.PlayerInfoText.LevelText.text + " " + this.SaveLoadList_mc.selectedEntry.level);
			}
			this.PlayerInfoText.textField.textAutoSize = "shrink";
			this.PlayerInfoText.textField.SetText(strSaveName);
		}
		if (this.SaveLoadList_mc.selectedEntry.playTime == undefined) 
		{
			this.PlayerInfoText.PlayTimeText.SetText(" ");
		}
		else 
		{
			this.PlayerInfoText.PlayTimeText.SetText(this.SaveLoadList_mc.selectedEntry.playTime);
		}
		if (this.SaveLoadList_mc.selectedEntry.dateString != undefined) 
		{
			this.PlayerInfoText.DateText.SetText(this.SaveLoadList_mc.selectedEntry.dateString);
			return;
		}
		this.PlayerInfoText.DateText.SetText(" ");
	}

	function onLoadInit(aTargetClip: MovieClip): Void
	{
		aTargetClip._width = this.ScreenshotHolder.sizer._width;
		aTargetClip._height = this.ScreenshotHolder.sizer._height;
	}

	function onSaveLoadBatchComplete(abDoInitialUpdate: Boolean): Void
	{
		var iSaveNameMaxLength: Number = 20;
		for (var i: String in this.SaveLoadList_mc.entryList) 
		{
			if (this.SaveLoadList_mc.entryList[i].text.length > iSaveNameMaxLength) 
			{
				this.SaveLoadList_mc.entryList[i].text = this.SaveLoadList_mc.entryList[i].text.substr(0, iSaveNameMaxLength - 3) + "...";
			}
		}
		if (abDoInitialUpdate) 
		{
			var strNewSave: String = "$[NEW SAVE]";
			if (this.bSaving && this.SaveLoadList_mc.entryList[0].text != strNewSave) 
			{
				var newSaveObj: Object = {name: " ", playTime: " ", text: strNewSave};
				this.SaveLoadList_mc.entryList.unshift(newSaveObj);
			}
			else if (!this.bSaving && this.SaveLoadList_mc.entryList[0].text == strNewSave) 
			{
				this.SaveLoadList_mc.entryList.shift();
			}
		}
		this.SaveLoadList_mc.InvalidateData();
		if (abDoInitialUpdate) 
		{
			if (this.iPlatform != 0) 
			{
				if (this.SaveLoadList_mc.selectedIndex == 0) 
				{
					this.onSaveLoadItemHighlight({index: 0});
				}
				else 
				{
					this.SaveLoadList_mc.selectedIndex = 0;
				}
			}
			this.dispatchEvent({type: "saveListPopulated"});
		}
	}

	function DeleteSelectedSave(): Void
	{
		if (!this.bSaving || this.SaveLoadList_mc.selectedIndex != 0) 
		{
			if (this.bSaving) 
			{
				gfx.io.GameDelegate.call("DeleteSave", [this.SaveLoadList_mc.selectedIndex - 1]);
			}
			else 
			{
				gfx.io.GameDelegate.call("DeleteSave", [this.SaveLoadList_mc.selectedIndex]);
			}
			this.SaveLoadList_mc.entryList.splice(this.SaveLoadList_mc.selectedIndex, 1);
			this.SaveLoadList_mc.InvalidateData();
			this.onSaveLoadItemHighlight({index: this.SaveLoadList_mc.selectedIndex});
		}
	}

}
