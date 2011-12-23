dynamic class WidgetOverlay.Graph extends MovieClip
{
	static var PLOT_BORDER: Number = 20;
	var Data;
	var Height;
	var LineColor;
	var LineWidth;
	var Plot;
	var PlotHeight;
	var PlotWidth;
	var Width;
	var XAxis;
	var XGridStep;
	var XLabel;
	var XMax;
	var XMaxLabel;
	var XMaxText;
	var XMin;
	var XMinLabel;
	var XMinText;
	var YAxis;
	var YGridStep;
	var YLabel;
	var YMax;
	var YMaxLabel;
	var YMaxText;
	var YMin;
	var YMinLabel;
	var YMinText;
	var bDrawGraphBorder;
	var bDrawGraphGrid;
	var bDrawWidgetBorder;
	var clear;
	var createEmptyMovieClip;
	var getNextHighestDepth;
	var lineStyle;
	var lineTo;
	var moveTo;

	function Graph()
	{
		super();
		this.XLabel = this.XAxis;
		this.XMinLabel = this.XMinText;
		this.XMinLabel.autoSize = "left";
		this.XMaxLabel = this.XMaxText;
		this.XMaxLabel.autoSize = "left";
		this.YLabel = this.YAxis;
		this.YMinLabel = this.YMinText;
		this.YMinLabel.autoSize = "left";
		this.YMaxLabel = this.YMaxText;
		this.YMaxLabel.autoSize = "left";
		this.Plot = this.createEmptyMovieClip("PlotClip", this.getNextHighestDepth());
		this.XMax = 0;
		this.XMin = 0;
		this.XGridStep = 0;
		this.YMax = 0;
		this.YMin = 0;
		this.YGridStep = 0;
		this.LineColor = 65280;
		this.LineWidth = 2;
		this.bDrawWidgetBorder = true;
		this.bDrawGraphBorder = true;
		this.bDrawGraphGrid = true;
		this.SetSize(100, 100);
	}

	function SetLabels(aXLabel, aYLabel)
	{
		this.XLabel.text = aXLabel;
		this.YLabel.text = aYLabel;
	}

	function SetShowLabels(abShowXLabel, abShowYLabel)
	{
		this.XLabel._visible = abShowXLabel;
		this.XMinLabel._visible = abShowXLabel;
		this.XMaxLabel._visible = abShowXLabel;
		this.YLabel._visible = abShowYLabel;
		this.YMinLabel._visible = abShowYLabel;
		this.YMaxLabel._visible = abShowYLabel;
		this.SetSize(this.Width, this.Height);
	}

	function SetLineColor(aColor)
	{
		this.LineColor = aColor;
	}

	function SetLineWidth(aWidth)
	{
		this.LineWidth = aWidth;
	}

	function SetSize(aWidth, aHeight)
	{
		this.Width = aWidth;
		this.Height = aHeight;
		this.PositionLabels();
		var __reg2 = this.YLabel._visible ? WidgetOverlay.Graph.PLOT_BORDER : 0;
		var __reg3 = this.XLabel._visible ? WidgetOverlay.Graph.PLOT_BORDER : 0;
		this.Plot._x = __reg2;
		this.Plot._y = aHeight - __reg3;
		this.PlotHeight = aHeight - __reg3;
		this.PlotWidth = aWidth - __reg2;
		this.DrawBackground();
	}

	function PositionLabels()
	{
		var __reg2 = this.YLabel._visible ? WidgetOverlay.Graph.PLOT_BORDER : 0;
		var __reg3 = this.XLabel._visible ? WidgetOverlay.Graph.PLOT_BORDER : 0;
		this.XLabel._y = this.Height - WidgetOverlay.Graph.PLOT_BORDER;
		this.XMinLabel._y = this.XLabel._y;
		this.XMinLabel._x = __reg2 - this.XMinLabel._width / 2;
		this.XMaxLabel._y = this.XMinLabel._y;
		this.XMaxLabel._x = this.Width - this.XMaxLabel._width / 2;
		this.YLabel._y = this.Height - WidgetOverlay.Graph.PLOT_BORDER;
		this.YMinLabel._y = this.Height - __reg3 - this.YMinLabel._height / 2;
		this.YMinLabel._x = WidgetOverlay.Graph.PLOT_BORDER - this.YMinLabel._width;
		this.YMaxLabel._y = (0 - this.YMaxLabel._height) / 2;
		this.YMaxLabel._x = WidgetOverlay.Graph.PLOT_BORDER - this.YMaxLabel._width;
	}

	function SetDrawBackground(aDrawWidgetBorder, aDrawGraphBorder, aDrawGraphGrid)
	{
		this.bDrawWidgetBorder = aDrawWidgetBorder;
		this.bDrawGraphBorder = aDrawGraphBorder;
		this.bDrawGraphGrid = aDrawGraphGrid;
		this.DrawBackground();
	}

	function DrawBackground()
	{
		this.clear();
		this.lineStyle(1, 0, 100, false, "none");
		if (this.bDrawWidgetBorder) 
		{
			this.moveTo(0, 0);
			this.lineTo(0, this.Height);
			this.lineTo(this.Width, this.Height);
			this.lineTo(this.Width, 0);
			this.lineTo(0, 0);
		}
		if (this.bDrawGraphBorder) 
		{
			this.moveTo(this.Plot._x, this.Plot._y);
			this.lineTo(this.Plot._x + this.PlotWidth, this.Plot._y);
			this.lineTo(this.Plot._x + this.PlotWidth, 0);
			this.lineTo(this.Plot._x, 0);
			this.lineTo(this.Plot._x, this.Plot._y);
		}
		if (this.bDrawGraphGrid) 
		{
			if (this.XMax != this.XMin) 
			{
				var __reg4 = this.XGridStep / (this.XMax - this.XMin) * this.PlotWidth;
				var __reg3 = __reg4 + this.Plot._x;
				while (__reg3 < this.Width) 
				{
					this.moveTo(__reg3, this.Plot._y);
					this.lineTo(__reg3, 0);
					__reg3 = __reg3 + __reg4;
				}
			}
			if (this.YMax != this.YMin) 
			{
				var __reg5 = this.YGridStep / (this.YMax - this.YMin) * this.PlotHeight;
				var __reg2 = this.Plot._y - __reg5;
				for (;;) 
				{
					if (__reg2 <= 0) 
					{
						return;
					}
					this.moveTo(this.Plot._x, __reg2);
					this.lineTo(this.Width, __reg2);
					__reg2 = __reg2 - __reg5;
				}
			}
		}
	}

	function SetXExtents(aMax, aMin, aStep)
	{
		this.XMax = aMax;
		this.XMaxLabel.text = String(aMax);
		this.XMin = aMin;
		this.XMinLabel.text = String(aMin);
		this.XGridStep = aStep;
		this.PositionLabels();
		this.DrawBackground();
	}

	function SetYExtents(aMax, aMin, aStep)
	{
		this.YMax = aMax;
		this.YMaxLabel.text = String(aMax);
		this.YMin = aMin;
		this.YMinLabel.text = String(aMin);
		this.YGridStep = aStep;
		this.PositionLabels();
		this.DrawBackground();
	}

	function Clear()
	{
		this.Plot.clear();
	}

	function PlotLine()
	{
		if (this.XMax != this.XMin && this.YMax != this.YMin) 
		{
			var __reg4 = this.PlotWidth / (this.XMax - this.XMin);
			var __reg3 = (0 - this.PlotHeight) / (this.YMax - this.YMin);
			if (this.Data.length > 1) 
			{
				this.Plot.lineStyle(this.LineWidth, this.LineColor, 100, false, "none", "none", "miter");
				this.Plot.moveTo(__reg4 * (this.Data[0] - this.XMin), __reg3 * (this.Data[1] - this.YMin));
				var __reg2 = 2;
				for (;;) 
				{
					if (__reg2 >= this.Data.length - 1) 
					{
						return;
					}
					this.Plot.lineTo(__reg4 * (this.Data[__reg2] - this.XMin), __reg3 * (this.Data[__reg2 + 1] - this.YMin));
					__reg2 = __reg2 + 2;
				}
			}
		}
	}

}
