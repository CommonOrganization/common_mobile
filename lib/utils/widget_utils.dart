List getGatheringCardTagList(List tagList){
  if(tagList.length<=1) return tagList;
  if(tagList.first.length+tagList[1].length>10){
    return [tagList.first];
  }
  return tagList.sublist(0,2);
}