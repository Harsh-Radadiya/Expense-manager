

class Utils {
  static Map monthMap = {
    '01': 'January',
    '02': 'February',
    '03': 'March',
    '04': 'April',
    '05': 'May',
    '06': 'June	',
    '07': 'July',
    '08': 'August',
    '09': 'September',
    '10': 'October',
    '11': 'November',
    '12': 'December',
  };

  static getMonthString(String dateDetail) {
    var date = dateDetail.split('-');
    return monthMap[date[1]] + ' ' + date[0];
  }

}
