USE [THITRUONGCHUNGKHOAN]
GO

/****** Object:  StoredProcedure [dbo].[SP_CAP_NHAP_GIA_KL_MUA_BAN_BGTT]    Script Date: 09/05/2022 3:30:15 CH ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_CAP_NHAP_GIA_KL_MUA_BAN_BGTT] 
	@MACP nchar(7)
AS
	IF NOT EXISTS (SELECT * FROM BANGGIATRUCTUYEN WHERE MACP = @MACP)
	BEGIN
		INSERT INTO BANGGIATRUCTUYEN(MACP) VALUES (@MACP)
	END
	
	DECLARE @GiaMua1 FLOAT, @KLMua1 INT,
			@GiaMua2 FLOAT, @KLMua2 INT,
			@GiaMua3 FLOAT, @KLMua3 INT,
			@GiaBan1 FLOAT, @KLBan1 INT,
			@GiaBan2 FLOAT, @KLBan2 INT,
			@GiaBan3 FLOAT, @KLBan3 INT	

	SET @GiaMua1 = (SELECT MAX(GIADAT) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'M' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE))
	SET @KLMua1 = (SELECT SUM(SOLUONG) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'M' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) AND GIADAT = @GiaMua1)
	SET @GiaMua2 = (SELECT MAX(GIADAT) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'M' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) 
			AND GIADAT < @GiaMua1)
	SET @KLMua2 = (SELECT SUM(SOLUONG) 
		FROM LENHDAT WHERE MACP = @MACP AND LOAIGD = 'M' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) 
			AND GIADAT = @GiaMua2)
	SET @GiaMua3 = (SELECT MAX(GIADAT) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'M' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) 
			AND GIADAT < @GiaMua2)
	SET @KLMua3 = (SELECT SUM(SOLUONG) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'M' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) 
			AND GIADAT = @GiaMua3)

	SET @GiaBan1 = (SELECT MIN(GIADAT) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'B' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE))
	SET @KLBan1 = (SELECT SUM(SOLUONG) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'B' AND SOLUONG > 0 
		AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) AND GIADAT = @GiaBan1)
	SET @GiaBan2 = (SELECT MIN(GIADAT) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'B' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) 
			AND GIADAT > @GiaBan1)
	SET @KLBan2 = (SELECT SUM(SOLUONG) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'B' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) AND GIADAT = @GiaBan2)
	SET @GiaBan3 = (SELECT MIN(GIADAT) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'B' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) 
			AND GIADAT > @GiaBan2)
	SET @KLBan3 = (SELECT SUM(SOLUONG) FROM LENHDAT 
		WHERE MACP = @MACP AND LOAIGD = 'B' AND SOLUONG > 0 
			AND CAST(NGAYDAT AS DATE) = CAST(GETDATE() AS DATE) AND GIADAT = @GiaBan3)

	UPDATE BANGGIATRUCTUYEN SET GiaMua1 = @GiaMua1, KLMUA1 = @KLMua1,
								GiaMua2 = @GiaMua2, KLMUA2 = @KLMua2,
								GiaMua3 = @GiaMua3, KLMUA3 = @KLMua3,
									
								GiaBan1 = @GiaBan1, KLBAN1 = @KLBan1,
								GiaBan2 = @GiaBan2, KLBAN2 = @KLBan2,
								GiaBan3 = @GiaBan3, KLBAN3 = @KLBan3
		WHERE MACP = @MACP 
	--select @GiaMua1, @GiaMua2, @GiaMua3
	return 0
GO

