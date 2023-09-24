using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.DataModels
{
    public class TeamSummary
    {
        public int TeamId { get; set; }
        public string? Name { get; set; }
        public string? Stadium { get; set; }
        public string? LogoUrl { get; set; }
        public string? HomePageUrl { get; set; }
        public int HomeGamesPlayed { get; set; }
        public int AwayGamesPlayed { get; set; }
        public int TotalGamesPlayed { get; set; }
        public int TotalGamesLost { get; set; }
        public int TotalGamesWon { get; set; }
        public string? MVP { get; set; }
        public int BiggestWinPointsFor { get; set; }
        public int BiggestWinPointsAgainst { get; set; }
        public int BiggestLossPointsFor { get; set; }
        public int BiggestLossPointsAgainst { get; set; }
        public DateTime LastGameDate { get; set; }
        public string? LastGameStadium { get; set; }
    }
}
