import 'package:dating_app/resourses/colors.dart';
import 'package:dating_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class TextWithSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onToggle;
  final String text;
  final bool checkIcon;
  final bool withQuestion;

  TextWithSwitch({
    this.value,
    this.onToggle,
    this.text,
    this.checkIcon,
    this.withQuestion,
  });

  SuperTooltip get tooltip => SuperTooltip(
      popupDirection: TooltipDirection.down,
      showCloseButton: ShowCloseButton.inside,
      closeButtonColor: AppColors.orange,
      shadowColor: AppColors.lightBlack.withOpacity(0.5),
      shadowBlurRadius: 30,
      shadowSpreadRadius: 10,
      left: 50,
      maxWidth: 200,
      borderWidth: 1,
      arrowLength: 0,
      arrowBaseWidth: 0,
      arrowTipDistance: 20,
      borderColor: AppColors.orange,
      content: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 18),
          child: Text(
            'If you do not want your name to be displayed, then enable this function.',
            style: TextStyle(
              color: AppColors.black,
              height: 1.3,
            ),
          ),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  color: AppColors.lightBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              withQuestion != null && withQuestion == true ? SizedBox(width: 8) : Container(),
              withQuestion != null && withQuestion == true
                  ? InkWell(
                      onTap: () {
                        tooltip.show(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.orange, width: 1),
                        ),
                        child: Text(
                          '?',
                          style: TextStyle(
                            color: AppColors.orange,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SwitchBox(
            value: value,
            onToggle: onToggle,
            checkIcon: checkIcon,
          ),
        ],
      ),
    );
  }
}
