import 'package:flutter/material.dart';

class FolderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Các tham số này bạn có thể tuỳ chỉnh để tab to nhỏ tuỳ sở thích
    final double tabHeight = size.height * 0.25;
    final double tabWidth = size.width * 0.35;
    final double tabRadius = 14;
    final double radius = 16;

    final path = Path();

    // (1) Bắt đầu tại góc trên trái (tọa độ 0,0)
    path.moveTo(0, tabRadius);
    // (2) Bo nhẹ góc trên trái đi sang phải theo bán kính `radius`
    path.quadraticBezierTo(0, 0, tabRadius, 0);
    // (3) Vẽ cạnh trên tới gần phần tab (đi tới x = tabWidth - radius)
    path.lineTo(tabWidth - tabRadius, 0);
    // (4) Bo cong cạnh trái của tab xuống tới đáy tab (kết thúc tại điểm tabRadius + tabWidth, tabHeight)
    path.quadraticBezierTo(
      tabRadius * 2 + tabWidth,
      tabHeight,
      tabRadius * 2 + tabWidth,
      tabHeight,
    );
    // (5) Vẽ tiếp cạnh trên qua phần tab sang phải tới gần góc trên phải của card
    path.lineTo(size.width - tabRadius, tabHeight);
    // (6) Bo góc trên phải (từ trên xuống phải theo bán kính `radius`)
    path.quadraticBezierTo(
      size.width,
      tabHeight,
      size.width,
      tabHeight + radius,
    );
    // (7) Kéo cạnh phải card xuống đến trước góc dưới phải (đường thẳng)
    path.lineTo(size.width, size.height - radius);
    // (8) Bo góc dưới phải về phía trái theo bán kính `radius`
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );
    // (9) Vẽ cạnh dưới sang trái tới trước góc dưới trái (đi tới x = radius)
    path.lineTo(radius, size.height);
    // (10) Bo góc dưới trái lên phía trên theo bán kính `radius`
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    // (11) Kéo cạnh trái lên tới ngay dưới phần tab (đi tới y = tabHeight + radius)
    path.lineTo(0, tabHeight + radius);
    // (12) Sau khi vẽ xong các cạnh, path sẽ được đóng (path.close() bên ngoài selection)

    path.close();
    return path;
  }

  @override
  bool shouldReclip(FolderClipper oldClipper) => false;
}
