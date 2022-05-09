USE [THITRUONGCHUNGKHOAN]
GO

/****** Object:  StoredProcedure [dbo].[SP_CAP_NHAP_TAT_CA_GIA_KL_MUA_BAN_BGTT]    Script Date: 09/05/2022 3:30:25 CH ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[SP_CAP_NHAP_TAT_CA_GIA_KL_MUA_BAN_BGTT]
as
	DECLARE @CursorVariable CURSOR, @MACP NCHAR(7)
	SET @CursorVariable = CURSOR FOR SELECT MACP FROM BANGGIATRUCTUYEN
	OPEN @CursorVariable

	FETCH NEXT FROM @CursorVariable INTO @MACP
	WHILE(@@FETCH_STATUS <>-1)
	BEGIN
		EXEC SP_CAP_NHAP_GIA_KL_MUA_BAN_BGTT @MACP
		FETCH NEXT FROM @CursorVariable INTO @MACP
	END
	CLOSE @CursorVariable 
	DEALLOCATE @CursorVariable

	return 0
GO

