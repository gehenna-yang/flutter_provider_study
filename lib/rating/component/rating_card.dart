import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/colors.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  // NetworkImage
  // AssetImage
  //
  // CircleAvatar
  final ImageProvider avatarImage;
  // list image
  final List<Image> images;
  // rating
  final int rating;
  // writer email
  final String email;
  // review content
  final String content;

  const RatingCard({
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        const SizedBox(height: 8),
        _Body(content: content,),
        if(images.length > 0)
          SizedBox(
            height: 100,
            child: _Images(images: images,)
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;
  const _Header({
    required this.avatarImage,
    required this.rating,
    required this.email,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundImage: avatarImage,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(email, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),),
        ),
        ...List.generate(5, (index) => Icon(index < rating ? Icons.star:Icons.star_border_outlined, color: PRIMARY_COLOR,)),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(content, style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;
  const _Images({
    required this.images,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images.mapIndexed(
        (index, e) => Padding(
          padding: EdgeInsets.only(right: index == images.length-1 ? 0:16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: e,
          ),
        ),
      ).toList(),
    );
  }
}



