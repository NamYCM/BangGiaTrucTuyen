USE [THITRUONGCHUNGKHOAN]
GO

/****** Object:  Trigger [dbo].[TRIGGER_LENHKHOP]    Script Date: 09/05/2022 3:30:53 CH ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRIGGER_LENHKHOP]
ON [dbo].[LENHKHOP] 
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @CursorVariable CURSOR, @IDLENHDAT INT, @SOLUONGKHOP INT, @GIAKHOP FLOAT, @MACP NCHAR(7)

	--Update cho lệnh inserted
	SET @CursorVariable = CURSOR FOR SELECT IDLENHDAT, SOLUONGKHOP, GIAKHOP FROM inserted order by NGAYKHOP asc
	OPEN @CursorVariable

	FETCH NEXT FROM @CursorVariable INTO @IDLENHDAT, @SOLUONGKHOP, @GIAKHOP
	WHILE(@@FETCH_STATUS <>-1)
	BEGIN
		SET @MACP = (SELECT MACP FROM LENHDAT WHERE ID = @IDLENHDAT)
		UPDATE BANGGIATRUCTUYEN 
		SET GIAKHOP = @GIAKHOP,
			KLKHOP = @SOLUONGKHOP,
			TONGKL = TONGKL + @SOLUONGKHOP
		WHERE MACP = @MACP
		FETCH NEXT FROM @CursorVariable INTO @IDLENHDAT, @SOLUONGKHOP, @GIAKHOP
	END
	CLOSE @CursorVariable 
	DEALLOCATE @CursorVariable

	--Update cho lệnh deleted
	SET @CursorVariable = CURSOR FOR SELECT IDLENHDAT, SOLUONGKHOP FROM deleted
	OPEN @CursorVariable

	FETCH NEXT FROM @CursorVariable INTO @IDLENHDAT, @SOLUONGKHOP
	WHILE(@@FETCH_STATUS <>-1)
	BEGIN
		SET @MACP = (SELECT MACP FROM LENHDAT WHERE ID = @IDLENHDAT)
		DECLARE @GIAMOI FLOAT, @KLMOI INT
		SELECT TOP(1) @GIAMOI = GIAKHOP, @KLMOI = SOLUONGKHOP FROM LENHKHOP ORDER BY NGAYKHOP DESC
		UPDATE BANGGIATRUCTUYEN 
		SET GIAKHOP = @GIAMOI,
			KLKHOP = @KLMOI,
			TONGKL = TONGKL - @SOLUONGKHOP
		WHERE MACP = @MACP
		FETCH NEXT FROM @CursorVariable INTO @IDLENHDAT, @SOLUONGKHOP
	END
	CLOSE @CursorVariable 
	DEALLOCATE @CursorVariable
END
GO

ALTER TABLE [dbo].[LENHKHOP] ENABLE TRIGGER [TRIGGER_LENHKHOP]
GO

