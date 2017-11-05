boolean mouseOnPlay () {
  if (mouseX > width/2 - btnWidth/2 && mouseX < width/2 + btnWidth/2 && mouseY > height/2 - (btnHeight + 10) - btnHeight/2 && mouseY < height/2 - (btnHeight + 10) + btnHeight/2) {
    return true;
  } else {
    return false;
  }
}

boolean mouseOnQuit () {
  if (mouseX > width/2 - btnWidth/2 && mouseX < width/2 + btnWidth/2 && mouseY > height/2 + (btnHeight + 10) - btnHeight/2 && mouseY < height/2 + (btnHeight + 10) + btnHeight/2) {
    return true;
  } else {
    return false;
  }
}

boolean mouseOnLeaderboards () {
  if (mouseX > width/2 - btnWidth/2 && mouseX < width/2 + btnWidth/2 && mouseY > height/2 - btnHeight/2 && mouseY < height/2 + btnHeight/2) {
    return true;
  } else {
    return false;
  }
}

boolean mouseOnYes () {
  if (mouseX > width/2 - btnWidth/2 && mouseX < width/2 + btnWidth/2 && mouseY > (height - 200) - btnHeight/2 && mouseY < (height - 200) + btnHeight/2) {
    return true;
  } else {
    return false;
  }
}

boolean mouseOnNo () {
  if (mouseX > width/2 - btnWidth/2 && mouseX < width/2 + btnWidth/2 && mouseY > (height - 190 + btnHeight) - btnHeight/2 && mouseY < (height - 190 + btnHeight) + btnHeight/2) {
    return true;
  } else {
    return false;
  }
}

boolean mouseOnBack () {
  if (mouseX > width/2 - btnWidth/2 && mouseX < width/2 + btnWidth/2 && mouseY > (height - 100) - btnHeight/2 && mouseY < (height - 100) + btnHeight/2) {
    return true;
  } else {
    return false;
  }
}