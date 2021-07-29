package com.unsam.pds.dominio.entidades

import com.itextpdf.text.BaseColor
import com.itextpdf.text.Document
import com.itextpdf.text.DocumentException
import com.itextpdf.text.Element
import com.itextpdf.text.Font
import com.itextpdf.text.Image
import com.itextpdf.text.PageSize
import com.itextpdf.text.Paragraph
import com.itextpdf.text.Phrase
import com.itextpdf.text.pdf.BaseFont
import com.itextpdf.text.pdf.PdfContentByte
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.pdf.PdfPTable
import com.itextpdf.text.pdf.PdfWriter
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.OutputStream
import java.net.URL
import java.text.DecimalFormat
import java.time.format.DateTimeFormatter
import javax.servlet.http.HttpServletResponse
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class PdfRemito {
	String urlLogo
		
	Usuario usuario
	Document document
	Remito remito
	Font smallBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD)
	Font catFont = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.NORMAL)
	Font titleFont = new Font(Font.FontFamily.TIMES_ROMAN, 16, Font.BOLD)
	Font catFontBold = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD)
	Font small = new Font(Font.FontFamily.TIMES_ROMAN, 10)
	BaseFont bfBold
	BaseFont bf

	def ByteArrayOutputStream createPdf() {
		try {
			var baos= new ByteArrayOutputStream()
			var OutputStream out = baos

			var Document document = new Document(PageSize.A4)
			initializeFonts()
			var docWriter = PdfWriter.getInstance(document, out)
			document.open()
			var PdfContentByte cb = docWriter.directContent

			addMetaData(document)
			addLogo(document)
			generateHeader(document, cb)
			addTitlePage(document)
			document.add(createTable())
			document.add(new Paragraph(" "))
			document.add(new Paragraph(" "))
//			document.add(generateFooter())

			document.close
			baos
		} catch (Exception e) {
			e.printStackTrace
			null
		}
	}

	def void export(HttpServletResponse response) throws DocumentException, IOException {
		var Document document = new Document(PageSize.A4)
		var writer = PdfWriter.getInstance(document, response.getOutputStream())
		initializeFonts()
		document.open()

		var PdfContentByte cb = writer.directContent

		addMetaData(document)
		addLogo(document)
		generateHeader(document, cb)
		addTitlePage(document)
		document.add(createTable())
		document.add(new Paragraph(" "))
		document.add(new Paragraph(" "))
//		document.add(generateFooter())
		document.close
	}

	def initializeFonts() throws DocumentException , IOException {
		try {
			bfBold = BaseFont.createFont(BaseFont.TIMES_BOLD, BaseFont.CP1252, BaseFont.NOT_EMBEDDED)
			bf = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED)

		} catch (DocumentException e) {
			e.printStackTrace
		} catch (IOException e) {
			e.printStackTrace
		}
	}

	def void addMetaData(Document document) {
		document.addTitle("Remito Nº: " + remito.idRemito)
		document.addSubject("Fecha:" + remito.fechaDeCreacion.format(DateTimeFormatter.ofPattern("yyyy")))
		document.addKeywords("Remito PDF")
		document.addAuthor(remito.cliente.nombre)
		document.addCreator("ABECAM")
	}

	def void addLogo(Document doc) throws DocumentException, Exception{
		try {
			println("logo url: " + urlLogo)
			var Image companyLogo = Image.getInstance(new URL(urlLogo))

			companyLogo.setAbsolutePosition(35, 700)
			companyLogo.scalePercent(20)
			doc.add(companyLogo)
		} catch (DocumentException dex) {
			dex.printStackTrace
		} catch (Exception ex) {
			ex.printStackTrace
		}
	}

	def generateHeader(Document doc, PdfContentByte cb) {
		try {
			cb.setLineWidth(1f)
			cb.roundRectangle(25, 705, 415, 115, 5)
			cb.moveTo(25, 800)
			cb.stroke

			createHeadings(cb, 150, 790, usuario.apellido.toUpperCase + " " + usuario.nombre.toUpperCase, 16)
			createHeadings(cb, 150, 775, "", 8)
			createHeadings(cb, 150, 760, "CUIT: 20-18043724-0", 12)
			createHeadings(cb, 150, 745, "Direccion: Av. 25 de Mayo 1954", 12)
			createHeadings(cb, 150, 730, "Ciudad: San Martín", 12)
			createHeadings(cb, 150, 715, "Teléfono: (011) 7894-0663", 12)

			cb.setLineWidth(1f)

			cb.roundRectangle(460, 770, 100, 50, 5)
			cb.roundRectangle(460, 705, 100, 50, 5)
			cb.moveTo(460, 797)
			cb.lineTo(560, 797)
			cb.moveTo(460, 732)
			cb.lineTo(560, 732)
			cb.stroke

			createHeadings(cb, 480, 804, "Remito", 12)
			createHeadings(cb, 502, 780, "" + remito.idRemito, 14)
			createHeadings(cb, 488, 739, "FECHA", 12)
			createHeadings(cb, 470, 715, remito.fechaDeCreacion.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")), 14)

			cb.setLineWidth(1f)
			cb.roundRectangle(25, 565, 540, 120, 5)
			cb.stroke

			cb.moveTo(25, 660)
			cb.lineTo(565, 660)
			cb.stroke

			createHeadings(cb, 265, 667, "CLIENTE", 12)
			createCliente(cb, 35, 643, "Nombre: " + remito.cliente.nombre, 11)
			createCliente(cb, 35, 626, "CUIT: " + remito.cliente.cuit, 11)
			createCliente(cb, 35, 608,
				"Dirección:  " + remito.cliente.direccion.calle + " " + remito.cliente.direccion.altura, 11)
			createCliente(cb, 35, 590,
				"Ciudad: " + remito.cliente.direccion.localidad + " (" + remito.cliente.direccion.provincia + ")", 11)
			createCliente(cb, 35, 572, "Teléfono: " + remito.cliente.contactos.get(0).telefonos.findFirst[t | t.esPrincipal].telefono, 11)

		} catch (Exception ex) {
			ex.printStackTrace
		}
	}

//	def PdfPTable generateFooter() {
//		try {
//			var PdfPTable table = new PdfPTable(2)
//			table.setTotalWidth(#[85f, 455])
//			table.setLockedWidth(true)
//
//			var strFecha = ""
//			var strNombre = ""
//			var strDocumento = ""
//
//			if (remito.comprobante !== null) {
//				strFecha = remito.comprobante.fechaHoraEntrega.format(
//					DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))
//				strNombre = remito.comprobante.nombre_completo
//				strDocumento = remito.comprobante.dni
//			}
//
//			var PdfPCell cell = new PdfPCell(new Phrase("COMPROBANTE DE ENTREGA", catFontBold))
//			cell.setColspan(2)
//			cell.setHorizontalAlignment(Element.ALIGN_CENTER)
//			cell.setVerticalAlignment(Element.ALIGN_BOTTOM)
//			cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
//			cell.setPaddingTop(5)
//			cell.setPaddingRight(5)
//			cell.setPaddingBottom(5)
//			table.addCell(cell)
//
//			cell = new PdfPCell(new Phrase("FECHA", smallBold))
//			cell.setColspan(1)
//			cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
//			cell.setVerticalAlignment(Element.ALIGN_BOTTOM)
//			cell.disableBorderSide(8)
//			cell.setPaddingTop(5)
//			cell.setPaddingRight(5)
//			cell.setPaddingBottom(5)
//			table.addCell(cell)
//
//			cell = new PdfPCell(new Phrase(strFecha, catFont))
//			cell.setColspan(1)
//			cell.setHorizontalAlignment(Element.ALIGN_LEFT)
//			cell.setVerticalAlignment(Element.ALIGN_BOTTOM)
//			cell.disableBorderSide(4)
//			cell.setPaddingTop(5)
//			cell.setPaddingBottom(5)
//			table.addCell(cell)
//
//			cell = new PdfPCell(new Phrase("NOMBRE", smallBold))
//			cell.setColspan(1)
//			cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
//			cell.setVerticalAlignment(Element.ALIGN_BOTTOM)
//			cell.disableBorderSide(8)
//			cell.setPaddingTop(5)
//			cell.setPaddingRight(5)
//			cell.setPaddingBottom(5)
//			table.addCell(cell)
//
//			cell = new PdfPCell(new Phrase(strNombre, catFont))
//			cell.setColspan(1)
//			cell.setHorizontalAlignment(Element.ALIGN_LEFT)
//			cell.setVerticalAlignment(Element.ALIGN_BOTTOM)
//			cell.disableBorderSide(4)
//			cell.setPaddingTop(5)
//			cell.setPaddingBottom(5)
//			table.addCell(cell)
//
//			cell = new PdfPCell(new Phrase("DOCUMENTO", smallBold))
//			cell.setColspan(1)
//			cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
//			cell.setVerticalAlignment(Element.ALIGN_BOTTOM)
//			cell.disableBorderSide(8)
//			cell.setPaddingTop(5)
//			cell.setPaddingRight(5)
//			cell.setPaddingBottom(5)
//			table.addCell(cell)
//
//			cell = new PdfPCell(new Phrase(strDocumento, catFont))
//			cell.setColspan(1)
//			cell.setHorizontalAlignment(Element.ALIGN_LEFT)
//			cell.setVerticalAlignment(Element.ALIGN_BOTTOM)
//			cell.disableBorderSide(4)
//			cell.setPaddingTop(5)
//			cell.setPaddingBottom(5)
//			table.addCell(cell)
//
//			table
//
//		} catch (Exception ex) {
//			ex.printStackTrace
//			null
//		}
//	}

	def PdfPTable createTable() throws DocumentException {
		var descuento = 0d
		var total = 0d
		var DecimalFormat df = new DecimalFormat("#,###.00")
		var PdfPTable table = new PdfPTable(6)
		table.setTotalWidth(#[40f, 90f, 205f, 65f, 75f, 70f])
		table.setLockedWidth(true)

		var PdfPCell cell = new PdfPCell(new Phrase("CANT.", smallBold))
		cell.setColspan(1)
		cell.setHorizontalAlignment(Element.ALIGN_CENTER)
		cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
		cell.setPaddingTop(5)
		cell.setPaddingBottom(5)
		table.addCell(cell)

		cell = new PdfPCell(new Phrase("CONCEPTO", smallBold))
		cell.setColspan(1)
		cell.setHorizontalAlignment(Element.ALIGN_CENTER)
		cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
		cell.setPaddingTop(5)
		cell.setPaddingBottom(5)
		table.addCell(cell)

		cell = new PdfPCell(new Phrase("DESCRIPCIÓN", smallBold))
		cell.setColspan(1)
		cell.setHorizontalAlignment(Element.ALIGN_CENTER)
		cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
		cell.setPaddingTop(5)
		cell.setPaddingBottom(5)
		table.addCell(cell)

		cell = new PdfPCell(new Phrase("PRECIO U.", smallBold))
		cell.setColspan(1)
		cell.setHorizontalAlignment(Element.ALIGN_CENTER)
		cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
		cell.setPaddingTop(5)
		cell.setPaddingBottom(5)
		table.addCell(cell)

		cell = new PdfPCell(new Phrase("DESCUENTO", smallBold))
		cell.setColspan(1)
		cell.setHorizontalAlignment(Element.ALIGN_CENTER)
		cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
		cell.setPaddingTop(5)
		cell.setPaddingBottom(5)
		table.addCell(cell)

		cell = new PdfPCell(new Phrase("IMPORTE", smallBold))
		cell.setColspan(1)
		cell.setHorizontalAlignment(Element.ALIGN_CENTER)
		cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
		cell.setPaddingTop(5)
		cell.setPaddingBottom(5)
		table.addCell(cell)

		for (ProductoRemito prodRto : remito.productosDelRemito) {
			cell = new PdfPCell(new Phrase(prodRto.cantidad + "", catFont))
			cell.setHorizontalAlignment(Element.ALIGN_CENTER)
			cell.setPaddingBottom(5)
			table.addCell(cell)

			table.addCell(new PdfPCell(new Phrase(prodRto.producto.nombre, catFont)))
			table.addCell(new PdfPCell(new Phrase(prodRto.producto.descripcion, catFont)))
			table.addCell(new PdfPCell(new Phrase("$ " + df.format(prodRto.precio_unitario), catFont)))
			table.addCell(new PdfPCell(new Phrase("% " + prodRto.descuento, catFont)))
			table.addCell(
				new PdfPCell(
					new Phrase("$ " +
						df.format((prodRto.precio_unitario * prodRto.cantidad) -
							(prodRto.precio_unitario * prodRto.descuento / 100)), catFont)))
			descuento += prodRto.precio_unitario * prodRto.descuento / 100
			total += (prodRto.precio_unitario * prodRto.cantidad)
		}

//		cell = new PdfPCell(new Phrase(" "))
//		cell.setColspan(1)
//		cell.setBorderWidthBottom(0)
//		cell.setBorderWidthLeft(0)
//		cell.setBorder(0)
//		cell.setBorderColorLeft(BaseColor.WHITE)
//		cell.setBorderColorBottom(BaseColor.WHITE)
//		cell.setPaddingBottom(5)
//		table.addCell(cell)
//		table.addCell(cell)
//		table.addCell(cell)
//		table.addCell(cell)

//		cell = new PdfPCell(new Phrase("SUMA", smallBold))
//		cell.setColspan(1)
//		cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
//		cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
//		cell.setPaddingBottom(5)
//		table.addCell(cell)

		remito.calcularTotal

//		cell = new PdfPCell(new Phrase(" $" + df.format(total), catFont))
//		cell.setColspan(1)
//		cell.setHorizontalAlignment(Element.ALIGN_LEFT)
//		cell.setPaddingBottom(5)
//		table.addCell(cell)

//		cell = new PdfPCell(new Phrase(" "))
//		cell.setColspan(1)
//		cell.setBorderWidthBottom(0)
//		cell.setBorderWidthLeft(0)
//		cell.setBorder(0)
//		cell.setBorderColorLeft(BaseColor.WHITE)
//		cell.setBorderColorBottom(BaseColor.WHITE)
//		cell.setPaddingBottom(5)
//		table.addCell(cell)
//		table.addCell(cell)
//		table.addCell(cell)
//		table.addCell(cell)

//		cell = new PdfPCell(new Phrase("DESCUENTO", smallBold))
//		cell.setColspan(1)
//		cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
//		cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
//		cell.setPaddingBottom(5)
//		table.addCell(cell)

//		cell = new PdfPCell(new Phrase(" $ " + df.format(descuento), catFont))
//		cell.setColspan(1)
//		cell.setHorizontalAlignment(Element.ALIGN_LEFT)
//		cell.setPaddingBottom(5)
//		table.addCell(cell)

		cell = new PdfPCell(new Phrase(" "))
		cell.setColspan(1)
		cell.setBorderWidthBottom(0)
		cell.setBorderWidthLeft(0)
		cell.setBorder(0)
		cell.setBorderColorLeft(BaseColor.WHITE)
		cell.setBorderColorBottom(BaseColor.WHITE)
		cell.setPaddingBottom(5)
		table.addCell(cell)
		table.addCell(cell)
		table.addCell(cell)
		table.addCell(cell)

		cell = new PdfPCell(new Phrase("TOTAL", smallBold))
		cell.setColspan(1)
		cell.setHorizontalAlignment(Element.ALIGN_RIGHT)
		cell.setBackgroundColor(BaseColor.LIGHT_GRAY)
		cell.setPaddingBottom(5)
		table.addCell(cell)

		cell = new PdfPCell(new Phrase(" $ " + df.format(total - descuento), catFont))
		cell.setColspan(1)
		cell.setHorizontalAlignment(Element.ALIGN_LEFT)
		cell.setPaddingBottom(5)
		table.addCell(cell)

		table
	}

/////////////////////////////////////////////////////////////////////////////
	def createHeadings(PdfContentByte cb, float x, float y, String text, int tam) {
		cb.beginText
		cb.setFontAndSize(bfBold, tam)
		cb.setFontAndSize(bfBold, tam)
		cb.setTextMatrix(x, y)
		cb.showText(text.trim)
		cb.endText
	}

	def void createCliente(PdfContentByte cb, float x, float y, String text, int tam) {
		cb.beginText
		cb.setFontAndSize(bf, tam)
		cb.setFontAndSize(bf, tam)
		cb.setTextMatrix(x, y)
		cb.showText(text.trim)
		cb.endText
	}

	def addEmptyLine(Paragraph paragraph, int number) {
		for (i : 0 ..< number) {
			paragraph.add(new Paragraph(" "))
		}
	}

	def void addTitlePage(Document document) throws DocumentException {
		var Paragraph preface = new Paragraph()
		addEmptyLine(preface, 1)
		addEmptyLine(preface, 2)
		document.add(preface)
		preface.setAlignment(Element.ALIGN_RIGHT)
		addEmptyLine(preface, 2)
		document.add(preface)
		addEmptyLine(preface, 2)
		document.add(preface)
	}

}
