module AssetsHelper

  def render_qr_code(asset)
    # URL adresa, kterou QR kód otevře
    url = asset_url(asset, host: request.host_with_port)

    qr = RQRCode::QRCode.new(url)
    qr.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
