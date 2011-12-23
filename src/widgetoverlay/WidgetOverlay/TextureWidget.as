dynamic class WidgetOverlay.TextureWidget extends MovieClip
{
	var StoredHeight;
	var StoredWidth;
	var TextureContainer;
	var TextureLoader;
	var createEmptyMovieClip;

	function TextureWidget()
	{
		super();
		this.TextureLoader = undefined;
		this.TextureContainer = undefined;
		this.StoredWidth = 0;
		this.StoredHeight = 0;
	}

	function SetDimensions(aWidth, aHeight)
	{
		this.StoredWidth = aWidth;
		this.StoredHeight = aHeight;
		if (undefined == this.TextureLoader && undefined != this.TextureContainer) 
		{
			this.TextureContainer._width = this.StoredWidth;
			this.TextureContainer._height = this.StoredHeight;
		}
	}

	function LoadTexture(aTexturePath)
	{
		if (undefined == this.TextureLoader) 
		{
			this.TextureLoader = WidgetOverlay.Utils.TextureLoader;
			if (undefined == this.TextureContainer) 
			{
				this.TextureContainer = this.createEmptyMovieClip("ContainerClip", 0);
			}
			this.TextureLoader.loadClip(aTexturePath, this.TextureContainer);
			this.TextureLoader.addListener(this);
		}
	}

	function RemoveTexture()
	{
		if (undefined != this.TextureContainer) 
		{
			this.TextureContainer.removeMovieClip();
		}
	}

	function onLoadInit(aTargetClip)
	{
		if (undefined != this.TextureLoader && aTargetClip == this.TextureContainer) 
		{
			if (undefined != this.TextureContainer) 
			{
				if (0 != this.StoredWidth) 
				{
					this.TextureContainer._width = this.StoredWidth;
				}
				if (0 != this.StoredHeight) 
				{
					this.TextureContainer._height = this.StoredHeight;
				}
			}
			this.TextureLoader.removeListener(this);
			this.TextureLoader = undefined;
		}
	}

}
